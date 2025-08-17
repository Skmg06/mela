-- Location: supabase/migrations/20250817130524_mela_complete_schema.sql
-- Schema Analysis: Fresh project - no existing schema
-- Integration Type: COMPLETE NEW SCHEMA
-- Dependencies: Full social-commerce platform

-- Step 1: Extensions & Types
CREATE TYPE public.user_role AS ENUM ('buyer', 'seller', 'admin');
CREATE TYPE public.reel_status AS ENUM ('draft', 'published', 'archived');
CREATE TYPE public.product_status AS ENUM ('draft', 'active', 'out_of_stock', 'archived');
CREATE TYPE public.order_status AS ENUM ('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled');
CREATE TYPE public.verification_status AS ENUM ('pending', 'verified', 'rejected');

-- Step 2: Core Tables (no foreign keys initially)

-- Critical intermediary table for PostgREST compatibility
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    username TEXT UNIQUE,
    role public.user_role DEFAULT 'buyer'::public.user_role,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    is_active BOOLEAN DEFAULT true,
    verification_status public.verification_status DEFAULT 'pending'::public.verification_status,
    business_name TEXT, -- For sellers
    business_address TEXT, -- For sellers
    follower_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Categories for products
CREATE TABLE public.categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT,
    is_featured BOOLEAN DEFAULT false,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Step 3: Business Tables (with foreign keys to existing tables)

-- Products table for sellers
CREATE TABLE public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    original_price DECIMAL(10,2), -- For discount display
    status public.product_status DEFAULT 'draft'::public.product_status,
    images JSONB DEFAULT '[]', -- Array of image URLs
    inventory_count INTEGER DEFAULT 0,
    tags JSONB DEFAULT '[]', -- Array of tags for search
    metadata JSONB DEFAULT '{}', -- Additional product info
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Reels table for social commerce content
CREATE TABLE public.reels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    video_url TEXT NOT NULL,
    thumbnail_url TEXT,
    duration INTEGER, -- Duration in seconds
    status public.reel_status DEFAULT 'draft'::public.reel_status,
    view_count INTEGER DEFAULT 0,
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    share_count INTEGER DEFAULT 0,
    tags JSONB DEFAULT '[]', -- Array of hashtags
    is_promoted BOOLEAN DEFAULT false, -- For promoted reels
    promotion_budget DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Product tags in reels (many-to-many)
CREATE TABLE public.reel_products (
    reel_id UUID REFERENCES public.reels(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    position_x DECIMAL(3,2), -- X coordinate (0-1) for product placement
    position_y DECIMAL(3,2), -- Y coordinate (0-1) for product placement
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reel_id, product_id)
);

-- Orders table
CREATE TABLE public.orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL,
    status public.order_status DEFAULT 'pending'::public.order_status,
    shipping_address JSONB NOT NULL, -- Full address object
    payment_method TEXT,
    payment_id TEXT, -- External payment provider ID
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Order items (products in each order)
CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
    seller_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Comments on reels
CREATE TABLE public.reel_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reel_id UUID REFERENCES public.reels(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    parent_id UUID REFERENCES public.reel_comments(id) ON DELETE CASCADE, -- For replies
    content TEXT NOT NULL,
    like_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Step 4: Junction Tables (Many-to-Many Relationships)

-- User follows (social feature)
CREATE TABLE public.user_follows (
    follower_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    following_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    CHECK (follower_id != following_id) -- Users can't follow themselves
);

-- Reel likes
CREATE TABLE public.reel_likes (
    reel_id UUID REFERENCES public.reels(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (reel_id, user_id)
);

-- Comment likes
CREATE TABLE public.comment_likes (
    comment_id UUID REFERENCES public.reel_comments(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (comment_id, user_id)
);

-- Wishlist (products users want to buy)
CREATE TABLE public.wishlists (
    product_id UUID REFERENCES public.products(id) ON DELETE CASCADE,
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, user_id)
);

-- Step 5: Essential Indexes for Performance
CREATE INDEX idx_user_profiles_username ON public.user_profiles(username);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);

CREATE INDEX idx_products_seller_id ON public.products(seller_id);
CREATE INDEX idx_products_category_id ON public.products(category_id);
CREATE INDEX idx_products_status ON public.products(status);
CREATE INDEX idx_products_price ON public.products(price);
CREATE INDEX idx_products_created_at ON public.products(created_at DESC);

CREATE INDEX idx_reels_creator_id ON public.reels(creator_id);
CREATE INDEX idx_reels_status ON public.reels(status);
CREATE INDEX idx_reels_created_at ON public.reels(created_at DESC);
CREATE INDEX idx_reels_view_count ON public.reels(view_count DESC);
CREATE INDEX idx_reels_like_count ON public.reels(like_count DESC);

CREATE INDEX idx_orders_buyer_id ON public.orders(buyer_id);
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_orders_created_at ON public.orders(created_at DESC);

CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX idx_order_items_product_id ON public.order_items(product_id);
CREATE INDEX idx_order_items_seller_id ON public.order_items(seller_id);

CREATE INDEX idx_reel_comments_reel_id ON public.reel_comments(reel_id);
CREATE INDEX idx_reel_comments_user_id ON public.reel_comments(user_id);
CREATE INDEX idx_reel_comments_parent_id ON public.reel_comments(parent_id);
CREATE INDEX idx_reel_comments_created_at ON public.reel_comments(created_at DESC);

CREATE INDEX idx_user_follows_follower ON public.user_follows(follower_id);
CREATE INDEX idx_user_follows_following ON public.user_follows(following_id);

CREATE INDEX idx_categories_featured ON public.categories(is_featured, sort_order);

-- Step 6: Storage Buckets for Media
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES 
    ('reel-videos', 'reel-videos', true, 52428800, ARRAY['video/mp4', 'video/webm', 'video/quicktime']), -- 50MB for videos
    ('product-images', 'product-images', true, 5242880, ARRAY['image/jpeg', 'image/png', 'image/webp']), -- 5MB for images
    ('user-avatars', 'user-avatars', true, 2097152, ARRAY['image/jpeg', 'image/png', 'image/webp']); -- 2MB for avatars

-- Step 7: Essential Functions
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

-- Function for automatic profile creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, username, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1) || '_' || substr(NEW.id::text, 1, 8)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'buyer')::public.user_role
  );  
  RETURN NEW;
END;
$$;

-- Function to update follower counts
CREATE OR REPLACE FUNCTION public.update_follow_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Increase follower count for the followed user
        UPDATE public.user_profiles 
        SET follower_count = follower_count + 1
        WHERE id = NEW.following_id;
        
        -- Increase following count for the follower
        UPDATE public.user_profiles 
        SET following_count = following_count + 1
        WHERE id = NEW.follower_id;
        
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Decrease follower count for the unfollowed user
        UPDATE public.user_profiles 
        SET follower_count = GREATEST(follower_count - 1, 0)
        WHERE id = OLD.following_id;
        
        -- Decrease following count for the unfollower
        UPDATE public.user_profiles 
        SET following_count = GREATEST(following_count - 1, 0)
        WHERE id = OLD.follower_id;
        
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$;

-- Function to update reel engagement counts
CREATE OR REPLACE FUNCTION public.update_reel_engagement()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_TABLE_NAME = 'reel_likes' THEN
        IF TG_OP = 'INSERT' THEN
            UPDATE public.reels 
            SET like_count = like_count + 1
            WHERE id = NEW.reel_id;
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE public.reels 
            SET like_count = GREATEST(like_count - 1, 0)
            WHERE id = OLD.reel_id;
            RETURN OLD;
        END IF;
    ELSIF TG_TABLE_NAME = 'reel_comments' THEN
        IF TG_OP = 'INSERT' THEN
            UPDATE public.reels 
            SET comment_count = comment_count + 1
            WHERE id = NEW.reel_id;
            RETURN NEW;
        ELSIF TG_OP = 'DELETE' THEN
            UPDATE public.reels 
            SET comment_count = GREATEST(comment_count - 1, 0)
            WHERE id = OLD.reel_id;
            RETURN OLD;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;

-- Step 8: Enable RLS on all tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reel_products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reel_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reel_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comment_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

-- Step 9: RLS Policies Using Corrected Patterns

-- Pattern 1: Core user table (user_profiles) - Simple only, no functions
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 4: Public read, private write for categories
CREATE POLICY "public_can_read_categories"
ON public.categories
FOR SELECT
TO public
USING (true);

CREATE POLICY "admins_manage_categories"
ON public.categories
FOR ALL
TO authenticated
USING (EXISTS (
    SELECT 1 FROM auth.users au
    WHERE au.id = auth.uid() 
    AND (au.raw_user_meta_data->>'role' = 'admin')
));

-- Pattern 2: Simple user ownership for products
CREATE POLICY "sellers_manage_own_products"
ON public.products
FOR ALL
TO authenticated
USING (seller_id = auth.uid())
WITH CHECK (seller_id = auth.uid());

CREATE POLICY "public_can_read_active_products"
ON public.products
FOR SELECT
TO public
USING (status = 'active');

-- Pattern 2: Simple user ownership for reels
CREATE POLICY "users_manage_own_reels"
ON public.reels
FOR ALL
TO authenticated
USING (creator_id = auth.uid())
WITH CHECK (creator_id = auth.uid());

CREATE POLICY "public_can_read_published_reels"
ON public.reels
FOR SELECT
TO public
USING (status = 'published');

-- Pattern 2: Simple user ownership for orders
CREATE POLICY "buyers_manage_own_orders"
ON public.orders
FOR ALL
TO authenticated
USING (buyer_id = auth.uid())
WITH CHECK (buyer_id = auth.uid());

-- Pattern 2: Order items viewable by buyer or seller
CREATE POLICY "order_participants_view_items"
ON public.order_items
FOR SELECT
TO authenticated
USING (
    seller_id = auth.uid() OR 
    EXISTS (
        SELECT 1 FROM public.orders o 
        WHERE o.id = order_id AND o.buyer_id = auth.uid()
    )
);

CREATE POLICY "buyers_create_order_items"
ON public.order_items
FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.orders o 
        WHERE o.id = order_id AND o.buyer_id = auth.uid()
    )
);

-- Pattern 2: Simple user ownership for comments
CREATE POLICY "users_manage_own_reel_comments"
ON public.reel_comments
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "public_can_read_reel_comments"
ON public.reel_comments
FOR SELECT
TO public
USING (true);

-- Pattern 2: Simple user ownership for social features
CREATE POLICY "users_manage_own_follows"
ON public.user_follows
FOR ALL
TO authenticated
USING (follower_id = auth.uid())
WITH CHECK (follower_id = auth.uid());

CREATE POLICY "public_can_read_follows"
ON public.user_follows
FOR SELECT
TO public
USING (true);

CREATE POLICY "users_manage_own_reel_likes"
ON public.reel_likes
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_comment_likes"
ON public.comment_likes
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_wishlists"
ON public.wishlists
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Pattern 4: Public read for reel products (product placement)
CREATE POLICY "public_can_read_reel_products"
ON public.reel_products
FOR SELECT
TO public
USING (true);

CREATE POLICY "reel_creators_manage_reel_products"
ON public.reel_products
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.reels r 
        WHERE r.id = reel_id AND r.creator_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.reels r 
        WHERE r.id = reel_id AND r.creator_id = auth.uid()
    )
);

-- Step 10: Storage RLS Policies

-- Reel videos - creators can upload, anyone can view
CREATE POLICY "creators_upload_reel_videos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'reel-videos' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "public_view_reel_videos"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'reel-videos');

CREATE POLICY "creators_manage_own_reel_videos"
ON storage.objects
FOR UPDATE, DELETE
TO authenticated
USING (
    bucket_id = 'reel-videos' 
    AND owner = auth.uid()
);

-- Product images - sellers can upload, anyone can view
CREATE POLICY "sellers_upload_product_images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'product-images' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "public_view_product_images"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'product-images');

CREATE POLICY "sellers_manage_own_product_images"
ON storage.objects
FOR UPDATE, DELETE
TO authenticated
USING (
    bucket_id = 'product-images' 
    AND owner = auth.uid()
);

-- User avatars - users can upload their own, anyone can view
CREATE POLICY "users_upload_own_avatars"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'user-avatars' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "public_view_user_avatars"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'user-avatars');

CREATE POLICY "users_manage_own_avatars"
ON storage.objects
FOR UPDATE, DELETE
TO authenticated
USING (
    bucket_id = 'user-avatars' 
    AND owner = auth.uid()
);

-- Step 11: Triggers
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE TRIGGER set_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_products_updated_at
    BEFORE UPDATE ON public.products
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_reels_updated_at
    BEFORE UPDATE ON public.reels
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_orders_updated_at
    BEFORE UPDATE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_reel_comments_updated_at
    BEFORE UPDATE ON public.reel_comments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER update_follow_counts_trigger
    AFTER INSERT OR DELETE ON public.user_follows
    FOR EACH ROW
    EXECUTE FUNCTION public.update_follow_counts();

CREATE TRIGGER update_reel_like_counts_trigger
    AFTER INSERT OR DELETE ON public.reel_likes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_reel_engagement();

CREATE TRIGGER update_reel_comment_counts_trigger
    AFTER INSERT OR DELETE ON public.reel_comments
    FOR EACH ROW
    EXECUTE FUNCTION public.update_reel_engagement();

-- Step 12: Mock Data for Testing
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    seller1_uuid UUID := gen_random_uuid();
    seller2_uuid UUID := gen_random_uuid();
    buyer1_uuid UUID := gen_random_uuid();
    buyer2_uuid UUID := gen_random_uuid();
    category1_uuid UUID := gen_random_uuid();
    category2_uuid UUID := gen_random_uuid();
    category3_uuid UUID := gen_random_uuid();
    product1_uuid UUID := gen_random_uuid();
    product2_uuid UUID := gen_random_uuid();
    product3_uuid UUID := gen_random_uuid();
    product4_uuid UUID := gen_random_uuid();
    reel1_uuid UUID := gen_random_uuid();
    reel2_uuid UUID := gen_random_uuid();
    reel3_uuid UUID := gen_random_uuid();
    order1_uuid UUID := gen_random_uuid();
    order2_uuid UUID := gen_random_uuid();
BEGIN
    -- Create auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@mela.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Mela Admin", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (seller1_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'fashionista@mela.com', crypt('seller123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Fashion Store", "username": "fashionista_store", "role": "seller"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (seller2_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'techguru@mela.com', crypt('seller123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Tech Guru", "username": "tech_guru", "role": "seller"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (buyer1_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'sarah@mela.com', crypt('buyer123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Johnson", "username": "sarah_j"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (buyer2_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'mike@mela.com', crypt('buyer123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Mike Chen", "username": "mike_chen"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Categories
    INSERT INTO public.categories (id, name, description, image_url, is_featured, sort_order)
    VALUES
        (category1_uuid, 'Fashion & Clothing', 'Trendy clothing and fashion accessories', 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300', true, 1),
        (category2_uuid, 'Electronics & Tech', 'Latest gadgets and electronic devices', 'https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300', true, 2),
        (category3_uuid, 'Home & Lifestyle', 'Home decor and lifestyle products', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=300', false, 3);

    -- Products
    INSERT INTO public.products (id, seller_id, category_id, name, description, price, original_price, status, images, inventory_count, tags)
    VALUES
        (product1_uuid, seller1_uuid, category1_uuid, 'Bohemian Summer Dress', 'Flowy bohemian dress perfect for summer occasions. Made with breathable cotton fabric.', 89.99, 129.99, 'active', 
         '["https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400", "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?w=400"]', 25, 
         '["dress", "bohemian", "summer", "cotton", "casual"]'),
        (product2_uuid, seller1_uuid, category1_uuid, 'Leather Crossbody Bag', 'Handcrafted genuine leather crossbody bag with adjustable strap.', 149.99, 199.99, 'active',
         '["https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400", "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400"]', 15,
         '["bag", "leather", "crossbody", "handcrafted", "accessories"]'),
        (product3_uuid, seller2_uuid, category2_uuid, 'Wireless Earbuds Pro', 'Premium wireless earbuds with noise cancellation and long battery life.', 199.99, 249.99, 'active',
         '["https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400", "https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400"]', 50,
         '["earbuds", "wireless", "audio", "tech", "bluetooth"]'),
        (product4_uuid, seller2_uuid, category2_uuid, 'Smart Fitness Watch', 'Advanced fitness tracker with heart rate monitoring and GPS.', 299.99, 399.99, 'active',
         '["https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400", "https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400"]', 30,
         '["smartwatch", "fitness", "health", "gps", "wearable"]');

    -- Reels
    INSERT INTO public.reels (id, creator_id, title, description, video_url, thumbnail_url, duration, status, view_count, like_count, comment_count, tags)
    VALUES
        (reel1_uuid, seller1_uuid, 'Summer Dress Collection 2024', 'Check out our latest bohemian summer dresses! Perfect for beach vacations and casual outings. #SummerFashion #BohoStyle', 
         'https://sample-videos.com/zip/10/mp4/480/SampleVideo_480x360_1mb.mp4', 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400', 30, 'published', 1250, 89, 12,
         '["summerfashion", "boho", "dress", "style", "fashion"]'),
        (reel2_uuid, seller2_uuid, 'Unboxing Wireless Earbuds Pro', 'Unboxing and first impressions of our new Wireless Earbuds Pro with premium sound quality! #TechReview #Audio', 
         'https://sample-videos.com/zip/10/mp4/480/SampleVideo_480x360_2mb.mp4', 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400', 45, 'published', 2100, 156, 28,
         '["tech", "earbuds", "unboxing", "review", "audio"]'),
        (reel3_uuid, seller1_uuid, 'How to Style a Crossbody Bag', 'Three different ways to style your leather crossbody bag for any occasion! #StyleTips #Fashion', 
         'https://sample-videos.com/zip/10/mp4/480/SampleVideo_480x360_1mb.mp4', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', 25, 'published', 875, 67, 8,
         '["styling", "bag", "accessories", "fashion", "tips"]');

    -- Reel products (product placement in reels)
    INSERT INTO public.reel_products (reel_id, product_id, position_x, position_y)
    VALUES
        (reel1_uuid, product1_uuid, 0.3, 0.7), -- Dress placement in first reel
        (reel2_uuid, product3_uuid, 0.5, 0.8), -- Earbuds placement in second reel
        (reel3_uuid, product2_uuid, 0.4, 0.6); -- Bag placement in third reel

    -- User follows (social connections)
    INSERT INTO public.user_follows (follower_id, following_id)
    VALUES
        (buyer1_uuid, seller1_uuid), -- Sarah follows Fashion Store
        (buyer1_uuid, seller2_uuid), -- Sarah follows Tech Guru
        (buyer2_uuid, seller1_uuid), -- Mike follows Fashion Store
        (buyer2_uuid, buyer1_uuid),  -- Mike follows Sarah
        (seller1_uuid, seller2_uuid); -- Fashion Store follows Tech Guru

    -- Reel likes
    INSERT INTO public.reel_likes (reel_id, user_id)
    VALUES
        (reel1_uuid, buyer1_uuid), -- Sarah likes dress reel
        (reel1_uuid, buyer2_uuid), -- Mike likes dress reel
        (reel2_uuid, buyer1_uuid), -- Sarah likes earbuds reel
        (reel2_uuid, buyer2_uuid), -- Mike likes earbuds reel
        (reel2_uuid, seller1_uuid), -- Fashion Store likes tech reel
        (reel3_uuid, buyer2_uuid); -- Mike likes bag styling reel

    -- Reel comments
    INSERT INTO public.reel_comments (reel_id, user_id, content, like_count)
    VALUES
        (reel1_uuid, buyer1_uuid, 'Absolutely love this dress! Perfect for summer 😍', 5),
        (reel1_uuid, buyer2_uuid, 'Great quality and style. Already ordered one!', 3),
        (reel2_uuid, buyer1_uuid, 'How is the battery life? Thinking of getting these.', 2),
        (reel2_uuid, seller1_uuid, 'Amazing review! Tech Guru always delivers quality content 👏', 4),
        (reel3_uuid, buyer2_uuid, 'Super helpful styling tips! Thanks for sharing', 1);

    -- Wishlists
    INSERT INTO public.wishlists (product_id, user_id)
    VALUES
        (product2_uuid, buyer1_uuid), -- Sarah wants the crossbody bag
        (product4_uuid, buyer1_uuid), -- Sarah wants the fitness watch
        (product1_uuid, buyer2_uuid), -- Mike wants the summer dress
        (product3_uuid, buyer2_uuid); -- Mike wants the earbuds

    -- Orders
    INSERT INTO public.orders (id, buyer_id, total_amount, status, shipping_address, payment_method, notes)
    VALUES
        (order1_uuid, buyer1_uuid, 239.98, 'delivered', 
         '{"street": "123 Oak Street", "city": "San Francisco", "state": "CA", "zipCode": "94102", "country": "USA", "name": "Sarah Johnson", "phone": "+1-555-0123"}'::jsonb,
         'credit_card', 'Please leave at front door if not home'),
        (order2_uuid, buyer2_uuid, 299.99, 'shipped',
         '{"street": "456 Pine Avenue", "city": "Los Angeles", "state": "CA", "zipCode": "90210", "country": "USA", "name": "Mike Chen", "phone": "+1-555-0124"}'::jsonb,
         'paypal', 'Ring doorbell upon delivery');

    -- Order items
    INSERT INTO public.order_items (order_id, product_id, seller_id, quantity, unit_price, total_price)
    VALUES
        (order1_uuid, product1_uuid, seller1_uuid, 1, 89.99, 89.99), -- Sarah bought dress
        (order1_uuid, product2_uuid, seller1_uuid, 1, 149.99, 149.99), -- Sarah bought bag
        (order2_uuid, product4_uuid, seller2_uuid, 1, 299.99, 299.99); -- Mike bought fitness watch

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;
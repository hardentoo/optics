{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
module Optics.Internal.Prism where

import Optics.Internal.Optic
import Optics.Internal.Profunctor

-- | Tag for a prism.
data A_Prism

-- | Constraints corresponding to a prism.
type instance Constraints A_Prism p f = (Choice p, Applicative f)

-- | Type synonym for a type-modifying prism.
type Prism s t a b = Optic A_Prism s t a b

-- | Type synonym for a type-preserving prism.
type Prism' s a = Optic' A_Prism s a

-- | Explicitly cast an optic to a prism.
toPrism :: Is k A_Prism => Optic k s t a b -> Prism s t a b
toPrism = sub
{-# INLINE toPrism #-}

-- | Build a prism from the van Laarhoven representation.
vlPrism :: (forall p f . (Choice p, Applicative f) => p a (f b) -> p s (f t)) -> Prism s t a b
vlPrism = Optic
{-# INLINE vlPrism #-}

-- | Build a prism from a constructor and a matcher.
prism :: (b -> t) -> (s -> Either t a) -> Prism s t a b
prism construct match =
  vlPrism (\ p -> dimap match (either pure (fmap construct)) (right' p))
{-# INLINE prism #-}

-- withPrism
-- matching
-- Market


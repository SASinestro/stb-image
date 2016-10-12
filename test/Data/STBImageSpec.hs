module Data.STBImageSpec (spec) where

import qualified Data.Vector.Storable as V
import           Test.Hspec
import           Test.QuickCheck

import           Data.STBImage

firstTenPixels :: V.Vector Color
firstTenPixels = V.fromList $ [
      RGBA 0x8B 0x84 0x5A 0xFF
    , RGBA 0x8D 0x88 0x5C 0xFF
    , RGBA 0x8E 0x83 0x59 0xFF
    , RGBA 0x8F 0x86 0x5B 0xFF
    , RGBA 0x8E 0x8B 0x5B 0xFF
    , RGBA 0x8F 0x8A 0x5E 0xFF
    , RGBA 0x92 0x8C 0x5F 0xFF
    , RGBA 0x93 0x8C 0x5E 0xFF
    , RGBA 0x93 0x8C 0x5D 0xFF
    , RGBA 0x94 0x8C 0x5F 0xFF
    ]

spec :: Spec
spec = do
    describe "image loader" $ do
        it "loads the first ten pixels correctly" $ do
            Right img <- loadImage "test/jellybeans.tga"
            V.take 10 (_pixels img) `shouldBe` firstTenPixels
        it "loads the same image in different formats" $ do
            Right img  <- loadImage "test/jellybeans.bmp"
            Right img' <- loadImage "test/jellybeans.tga"
            img `shouldBe` img'
    describe "image writer" $ do
        it "works idempotently" $ do
            Right img <- loadImage "test/jellybeans.tga"
            writeTGA "test/jellybeans-out.tga" img
            Right img' <- loadImage "test/jellybeans-out.tga"
            img `shouldBe` img'
        it "saves and reloads lossless images correctly across formats" $ do
            Right img <- loadImage "test/jellybeans.tga"
            writeBMP "test/jellybeans-out.bmp" img
            Right img' <- loadImage "test/jellybeans-out.bmp"
            img `shouldBe` img'
        it "saves and reloads PNG files correctly" $ do
            Right img <- loadImage "test/jellybeans.tga"
            writePNG "test/jellybeans-out.png" img
            Right img' <- loadImage "test/jellybeans-out.png"
            img `shouldBe` img'
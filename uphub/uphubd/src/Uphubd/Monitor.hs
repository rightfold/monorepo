module Uphubd.Monitor
  ( Monitor_id (..)
  ) where

import Codec.Serialise (Serialise)
import Data.ByteString (ByteString)

newtype Monitor_id =
  Monitor_id ByteString
    deriving stock (Eq, Ord, Show, Read)
    deriving newtype (Serialise)

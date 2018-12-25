module System.Zmq4.Cbor
  ( send_cbor
  ) where

import Codec.Serialise (Serialise, serialise)
import System.ZMQ4 (Flag, Sender, Socket, send)

import qualified Data.ByteString.Lazy as Byte_string.Lazy

send_cbor :: (Sender a, Serialise b) => Socket a -> [Flag] -> b -> IO ()
send_cbor s f = send s f . Byte_string.Lazy.toStrict . serialise

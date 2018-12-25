module System.Zmq4.Extra
  ( attach
  ) where

import qualified System.ZMQ4 as Zmq

attach :: Zmq.Socket a -> String -> IO ()
attach s ('B' : a) = Zmq.bind s a
attach s ('C' : a) = Zmq.connect s a
attach _ _ = fail "attach: invalid mode"

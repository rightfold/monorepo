module Uphubd.Scheduler
  ( -- * Scheduler
    Scheduler (..)
  , loop
  , step

    -- * Schedule
  , schedule

    -- * Distribute
  , distribute
  ) where

import Control.Concurrent (threadDelay)
import Control.Monad (forever)
import Data.Foldable (traverse_)
import Data.Maybe (fromJust)
import Data.Pool (Pool)
import Uphubd.Monitor (Monitor_id (..))

import qualified Data.Pool as Pool
import qualified Database.Postgresql as Pg
import qualified System.ZMQ4 as Zmq
import qualified System.Zmq4.Cbor as Zmq.Cbor

--------------------------------------------------------------------------------
-- Scheduler

data Scheduler =
  Scheduler
    { scheduler_database :: Pool Pg.Connection
    , scheduler_push     :: Zmq.Socket Zmq.Push }

loop :: Scheduler -> IO a
loop s = forever (threadDelay 1000000 *> step s)

step :: Scheduler -> IO ()
step s = schedule (scheduler_database s)
           >>= traverse_ (distribute (scheduler_push s))

--------------------------------------------------------------------------------
-- Schedule

schedule :: Pool Pg.Connection -> IO [Monitor_id]
schedule pool =
  Pool.withResource pool $ \conn ->
    let sql = "SELECT monitor_id FROM uphub.schedule" in
    schedule' <$> Pg.execute conn sql []

schedule' :: Pg.Result -> [Monitor_id]
schedule' = fmap (Monitor_id . fromJust . head) . Pg.tuples

--------------------------------------------------------------------------------
-- Distribute

distribute :: Zmq.Socket Zmq.Push -> Monitor_id -> IO ()
distribute s = Zmq.Cbor.send_cbor s []

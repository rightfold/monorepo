{-# LANGUAGE ApplicativeDo #-}

module Uphubd.Main.Uphubd_scheduler
  ( main
  , main'
  ) where

import Control.Applicative ((<**>))
import Data.ByteString (ByteString)
import Uphubd.Scheduler (Scheduler (..))

import qualified Data.Pool as Pool
import qualified Database.Postgresql as Pg
import qualified Options.Applicative as O
import qualified System.ZMQ4 as Zmq
import qualified System.Zmq4.Extra as Zmq.Extra
import qualified Uphubd.Scheduler as Scheduler

main :: IO a
main = Zmq.withContext main'

main' :: Zmq.Context -> IO a
main' zmq = do
  options <- O.execParser options_parser_info
  print options

  pool <- Pool.createPool (Pg.connect (options_database_dsn options))
                          Pg.disconnect 1 60 8

  Zmq.withSocket zmq Zmq.Push $ \push -> do
    Zmq.Extra.attach push (options_push_endpoint options)
    let scheduler = Scheduler pool push
    Scheduler.loop scheduler

data Options =
  Options
    { options_database_dsn :: ByteString
    , options_push_endpoint :: String }
  deriving stock (Eq, Show)

options_parser_info :: O.ParserInfo Options
options_parser_info =
  let parser = options_parser <**> O.helper
  in O.info parser O.fullDesc

options_parser :: O.Parser Options
options_parser = do
  options_database_dsn <- O.option O.str (O.long "database_dsn")
  options_push_endpoint <- O.option O.str (O.long "push_endpoint")
  pure Options {..}

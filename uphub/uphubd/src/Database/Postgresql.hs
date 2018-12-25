module Database.Postgresql
  ( Connection
  , Result
  , Error (..)
  , connect
  , disconnect
  , execute
  , tuples
  ) where

import Control.Exception (Exception, throwIO)
import Data.ByteString (ByteString)
import Data.Function ((&))
import System.IO.Unsafe (unsafeDupablePerformIO)

import qualified Database.PostgreSQL.LibPQ as Libpq

newtype Connection =
  Connection Libpq.Connection

newtype Result =
  Result Libpq.Result

data Error
  = Bad_connect Libpq.ConnStatus
  | Bad_result Libpq.ExecStatus
  | Unsupported_copy
  deriving stock (Eq, Show)
  deriving anyclass (Exception)

connect :: ByteString -> IO Connection
connect dsn = do
  conn <- Libpq.connectdb dsn
  Libpq.status conn >>= \case
    Libpq.ConnectionOk -> pure ()
    e -> Libpq.finish conn *> throwIO (Bad_connect e)
  pure (Connection conn)

disconnect :: Connection -> IO ()
disconnect (Connection conn) =
  -- TODO: Ensure memory-safety after Libpq.finish is called.
  Libpq.finish conn

execute :: Connection -> ByteString -> [Maybe ByteString] -> IO Result
execute (Connection conn) sql params = do
  let param v = (Libpq.Oid 0, v, Libpq.Text)
  let params' = fmap (fmap param) params
  result <- Libpq.execParams conn sql params' Libpq.Text
              >>= maybe (throwIO (Bad_result Libpq.FatalError)) pure
  Libpq.resultStatus result >>= \case
    Libpq.EmptyQuery      -> pure ()
    Libpq.CommandOk       -> pure ()
    Libpq.TuplesOk        -> pure ()
    Libpq.CopyOut         -> throwIO Unsupported_copy
    Libpq.CopyIn          -> throwIO Unsupported_copy
    Libpq.CopyBoth        -> throwIO Unsupported_copy
    e@Libpq.BadResponse   -> throwIO (Bad_result e)
    e@Libpq.NonfatalError -> throwIO (Bad_result e)
    e@Libpq.FatalError    -> throwIO (Bad_result e)
    Libpq.SingleTuple     -> pure ()
  pure (Result result)

tuples :: Result -> [[Maybe ByteString]]
tuples (Result res) =
  let nfields = Libpq.nfields res         & unsafeDupablePerformIO in
  let ntuples = Libpq.ntuples res         & unsafeDupablePerformIO in
  [ [ Libpq.getvalue' res tuple field     & unsafeDupablePerformIO
    | field <- [0 .. nfields - 1] ]
  | tuple <- [0 .. ntuples - 1] ]

{-# LANGUAGE OverloadedStrings #-}
module UI.FileBrowser.Main
       (renderFileBrowser, renderFileBrowserSearchPathEditor) where

import Brick.Types (Widget, Padding(..))
import Brick.Widgets.Core
       (str, txt, withAttr, (<+>), vLimit, padRight)
import qualified Brick.Widgets.Edit as E

import qualified Brick.Widgets.List as L
import Control.Lens.Getter (view)
import Config.Main (listSelectedAttr)
import UI.Draw.Main (fillLine)
import UI.Utils (focusedViewWidget)
import Types

renderFileBrowser :: AppState -> Widget Name
renderFileBrowser s = L.renderList drawListItem (ListOfFiles == focusedViewWidget s ListOfThreads)
                      $ view (asFileBrowser . fbEntries) s

drawListItem :: Bool -> (Bool, FileSystemEntry) -> Widget Name
drawListItem sel (toggled, x) = let toggled2Widget = if sel || toggled then withAttr listSelectedAttr else id
                                in toggled2Widget $ str (show x) <+> fillLine

renderFileBrowserSearchPathEditor :: AppState -> Widget Name
renderFileBrowserSearchPathEditor s =
  let hasFocus = ManageFileBrowserSearchPath == focusedViewWidget s ListOfThreads
      editorDrawContent = str . unlines
      inputW = E.renderEditor editorDrawContent hasFocus (view (asFileBrowser . fbSearchPath) s)
      labelW = padRight (Pad 1) $ txt "Path:"
  in labelW <+> vLimit 1 inputW

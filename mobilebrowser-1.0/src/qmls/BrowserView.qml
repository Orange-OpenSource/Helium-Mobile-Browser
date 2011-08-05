/*--------------------------------------------------------
* Module Name : Helium Mobile Browser
* Version : 1.0
*
* Software Name : Helium Mobile Browser
* Version : 1.0
*
* Copyright (c) 2010 - 2011 France Telecom
* This software is distributed under the LGPL v2.1 license,
* the text of which is available at http://www.gnu.org/licenses/lgpl-2.1.html
* or see the "LICENSE.txt" file for more details.
*
*--------------------------------------------------------
* File Name   : BrowserView.qml
*
* Created     : 15 June 2011
*
* Description :
*
* The main browser view
*
*--------------------------------------------------------
* 1.0 - First open source release
*
*/

import Qt 4.7

import "BrowserViewComponents"
import "common"

Item {
   id: browserView

   width: Orientation.screenWidth
   height: Orientation.screenHeight
   state: Orientation.state

   Item {
      id: webPanel
      anchors.fill: parent
      clip: true

      // The Gray background
      Background { anchors.fill: parent; z: -1; }


      // Header
      Header {
         id: header
         height: uiMetrics.topBarHeight;
         width: parent.width
         onUrlChanged: { webView.changeUrl(urlString); }
         loading: webView.loading

         z: 3
      }

      // WebView
      FlickableWebView {
         id: webView

         anchors.top: header.bottom
         anchors.bottom: footer.top
         anchors.left: parent.left
         anchors.right: parent.right

         onGotFocus: { header.abortEdit(); }
         onUrlChanged: { header.setDefaultFavIcon(); header.changeUrl(urlString); }
         onIconChanged: { header.updateFavIcon(); }

         z: 1
      }

      // Attach scrollbars to the right and bottom edges of the view.
      ScrollBar {
         id: verticalScrollBar
         verticalOrientation: true
         whenToShow: webView.moving
         positionInContent: webView.visibleArea.yPosition
         visibleContent: webView.visibleArea.heightRatio

         width: 8

         anchors.top: parent.top
         anchors.topMargin: header.height
         anchors.right: parent.right
         anchors.bottom: footer.top
         anchors.bottomMargin: 8

         z: 3
      }

      // Attach scrollbars to the right and bottom edges of the view.
      ScrollBar {
         id: horizontalScrollBar
         verticalOrientation: false
         whenToShow: webView.moving
         positionInContent: webView.visibleArea.xPosition
         visibleContent: webView.visibleArea.widthRatio

         height: 8

         anchors.left: parent.left
         anchors.right: parent.right
         anchors.rightMargin: 8
         anchors.bottom: footer.top

         z: 3
      }

      // Footer
      Footer {
         id: footer
         z: 3

         height: uiMetrics.bottomBarHeight

         onLostFocus: { webView.focus = true; }
         onBookmarkAdded: {
            var component = Qt.createComponent("common/TemporaryMessageWithIcon.qml");
            var message = component.createObject(browserView);
            message.iconSource = 'image://favicons/' + webView.url;
            message.title = "Bookmark Saved";
            message.subTitle = webView.title == "" ? webView.url : webView.title;
            message.showAndDestroy();
         }
      }
   }

   states:  [
       State {
           name: "Landscape"
           PropertyChanges {
               target: browserView
               rotation: Orientation.landscapeRotation
               x: Orientation.xPosition;
               y: Orientation.yPosition;
           }
       },
       State {
           name: "LandscapeInverted"
           PropertyChanges {
               target: browserView
               rotation: Orientation.landscapeInvertedRotation
               x: Orientation.xPosition;
               y: Orientation.yPosition;
           }
       },
       State {
           name: "Portrait"
           PropertyChanges {
               target: browserView
               rotation: Orientation.portraitRotation
               x: Orientation.xPosition;
               y: Orientation.yPosition;
           }
       },
       State {
           name: "PortraitInverted"
           PropertyChanges {
               target: browserView
               rotation: Orientation.portraitInvertedRotation
               x: Orientation.xPosition;
               y: Orientation.yPosition;
           }
       }
   ]

   onWidthChanged: {
       state = Orientation.state;
   }
   onHeightChanged: {
       state = Orientation.state;
   }

   transitions: [
       Transition {
           from: "*"
           to: "*"

           ParallelAnimation {
               RotationAnimation {
                   properties: "rotation"
                   duration: 250
                   direction: RotationAnimation.Shortest
               }
               PropertyAnimation {
                   target: browserView
                   properties: "x,y,width,height"
                   duration: 250
               }
           }
       }
   ]
}

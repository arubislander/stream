import QtQuick 2.7
import QtQuick.XmlListModel 2.0
import "utility.js" as Util

Item {
    property string server
    property string username
    //property string password
    property string salt
    property string token

    property string currentPlaylistId
    property string currentAlbumId
    property string currentArtistId
    property string currentPodcastId

    function getPlaylist(id) {
        return getUrl("getPlaylist", id)
    }

    function star(songid,callbackFunc) {
        callApi(getUrl("star", songid),callbackFunc)
    }

    function unstar(songid,callbackFunc) {
        callApi(getUrl("unstar", songid),callbackFunc)
    }

    function getCoverArt(id) {
        return getUrl("getCoverArt", id)
    }
    
    function getStreamSource(id) {
        return getUrl("stream", id)
    }

    function getBaseUrl(operation) {
        var url = server + "/rest/"+ operation + "?v=1.13&c=stream.sflt&u=" + username + "&s=" + salt + "&t="+ token
        return url
    }

    function getUrl(operation, id) {
        var url = getBaseUrl(operation) + (id == null ? "" : "&id=" + id)
        console.debug("url: " + url)
        return url
    }

    function getPlaylists() {
        return getUrl("getPlaylists")
    }

    function getStarred() {
        return getUrl("getStarred2")
    }
    
    function getPodcasts() {
        return getUrl("getPodcasts") + "&includeEpisodes=false"
    }

    function getPodcast(id) {
        return getUrl("getPodcasts", id)
    }

    function login(serverurl, username, password, callbackFunc) {
        var salt = Util.generateRandomSalt(12)
        var token = Util.getToken(password,salt)
        var url = serverurl + "/rest/ping.view?v=1.13&c=stream.sflt&u=" + username + "&s=" + salt + "&t=" + token
        callApi(url, callbackFunc)
    }

     function callApi(url, callbackFunc) {
        apiModel.callbackFunc = callbackFunc
        apiModel.source = url
    }

   XmlListModel {
        id: apiModel

        property var callbackFunc
        
        onStatusChanged: {
            console.log(apiModel.source)
            console.log(apiModel.status)
            console.log(apiModel.get(0))
            if (status == XmlListModel.Ready && callbackFunc) {
                callbackFunc(apiModel.get(0))
            }
        }

        namespaceDeclarations: "declare default element namespace 'http://subsonic.org/restapi';"
        query: "/subsonic-response"

        XmlRole { name: "status"; query: "@status/string()" }
        XmlRole { name: "errorcode"; query: "error/@code/string()" }
        XmlRole { name: "errormessage"; query: "error/@message/string()" }
    }
}
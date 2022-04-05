import QtQuick 2.7
import Qt.labs.settings 1.0

Item {
    property string name: "Subsonic"
    property alias client: _client
    property alias settings: _settings
    property alias playlistModel: _playlistModel
    property alias playlistsModel: _playlistsModel

    Item {
        id: _settings

        property string category: providerSettings.category

        property int accountType: providerSettings.accountType
        property string serverurl: providerSettings.serverurl
        property string username: providerSettings.username
        property string password: providerSettings.password

        function needsCredentials() {
            return password == ""
        }
    }


    SubsonicClient{
        id: _client

        server: _settings.serverurl
        username: _settings.username
        password: _settings.password
    }

    SubsonicPlaylistModel {
        id: _playlistModel

        source: _client.getPlaylist(client.currentPlaylistId)
    }

    SubsonicPlaylistsModel{
        id: _playlistsModel

        source: _client.getPlaylists()
    }
}
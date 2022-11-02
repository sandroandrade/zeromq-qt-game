pragma Singleton

import QtQuick 2.15

Item {
    id: fonts

    readonly property FontLoader fontAwesomeRegular: FontLoader {
        source: "qrc:///FontAwesome/FontAwesome-5-Free-Regular-400.otf"
    }
    property FontLoader fontAwesomeSolid: FontLoader {
        source: "qrc:///FontAwesome/FontAwesome-5-Free-Solid-900.otf"
    }
    property FontLoader fontAwesomeBrands: FontLoader {
        source: "qrc:///FontAwesome/FontAwesome-5-Brands-Regular-400.otf"
    }

    readonly property string regular: fonts.fontAwesomeRegular.name
    readonly property string solid: fonts.fontAwesomeSolid.name
    readonly property string brands: fonts.fontAwesomeBrands.name
}

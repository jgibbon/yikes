import QtQuick 2.0

import QtQuick.LocalStorage 2.0
import "PersistentObjectStore.js" as Store

QtObject {
	id: settings
	objectName: "default"

    property bool doPersist: true

	Component.onCompleted: {
        Store.initialize(['Yikes','1.0',objectName], LocalStorage);

        doPersist && Store.load(settings);
	}

	Component.onDestruction: {
        //save defaults even if !doPersist?
        doPersist && Store.save(settings);
	}
}

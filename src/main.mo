import Text "mo:core/Text";
import Iter "mo:core/Iter";

persistent actor {

    func getQueryParam(url : Text, key : Text) : ?Text {
        let parts = Iter.toArray(Text.split(url, #char '?'));
        if (parts.size() < 2) return null;
        for (param in Text.split(parts[1], #char '&')) {
            let kv = Iter.toArray(Text.split(param, #char '='));
            if (kv.size() == 2 and kv[0] == key) return ?kv[1];
        };
        null;
    };

    public query func http_request(req : { url : Text; method : Text; headers : [(Text, Text)]; body : Blob }) : async {
        status_code : Nat16;
        headers : [(Text, Text)];
        body : Blob;
    } {
        switch (getQueryParam(req.url, "password")) {
            case (?pwd) if (pwd == "secret") {
                {
                    status_code = 200;
                    headers = [("Content-Type", "text/plain")];
                    body = Text.encodeUtf8("# Secret Document\n\nProtected content here.");
                };
            } else {
                {
                    status_code = 404;
                    headers = [("Content-Type", "text/plain")];
                    body = Text.encodeUtf8("404 Not Found");
                };
            };
            case (null) {
                {
                    status_code = 200;
                    headers = [("Content-Type", "text/html")];
                    body = Text.encodeUtf8("<html><body><h3>Password</h3><input type='password' id='p'/><button onclick=\"location='?password='+document.getElementById('p').value\">OK</button></body></html>");
                };
            };
        };
    };
};

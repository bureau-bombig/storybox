//
//  LegalDocumentsView.swift
//  Storybox
//
//  Created by User on 12.05.24.
//

import SwiftUI

struct LegalDocumentsView: View {
    @Binding var selectedDocument: String
    @State private var scrollUp = false
    @State private var scrollDown = false
    
     var body: some View {
         VStack {
             WebView(htmlContent: loadHTMLContent(for: selectedDocument), baseURL: nil, scrollUp: $scrollUp, scrollDown: $scrollDown)
                 .edgesIgnoringSafeArea(.all)
                 .padding(.top, 120)
                 .padding(.leading, 160)
                 .padding(.trailing, 160)
                 .padding(.bottom, 40)
                 .onAppear {
                     NotificationCenter.default.addObserver(forName: NSNotification.Name("ScrollUpLegalDocument"), object: nil, queue: .main) { _ in
                         print("LegalDocumentsView: Scroll up")
                         self.scrollUp = true
                     }
                     NotificationCenter.default.addObserver(forName: NSNotification.Name("ScrollDownLegalDocument"), object: nil, queue: .main) { _ in
                         print("LegalDocumentsView: Scroll down")
                         self.scrollDown = true
                     }
                 }
                 .onDisappear {
                     NotificationCenter.default.removeObserver(self)
                 }
         }
         .background(Color.appPrimary)
     }
    
    func loadHTMLContent(for document: String) -> String {
        switch document {
        case "gdpr":
            return loadGdpr()
        case "consent":
            return loadConsent()
        case "condition":
            return loadCondition()
        default:
            return "<p>Error: Document not found.</p>"
        }
    }
     
    
    func loadConsent() -> String {
        return """
        <html>
        <head>
        <style>
            body {
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                font-size: 20px; /* Increased base font size from default to 20px */
                line-height: 1.6;
            }
            h1 {
                font-size: 24px; /* Increased heading 1 font size */
                margin-top: 20px;
            }
            h2 {
                font-size: 22px; /* Increased heading 2 font size */
            }
            h3 {
                font-size: 21px; /* Increased heading 3 font size */
            }
            p {
                margin-top: 10px;
            }
        </style>
        </head>
        <body>
        <h1>EINWILLIGUNGSERKLÄRUNG </h1>

        <p>Hiermit willige ich in die Verarbeitung meiner personenbezogenen Daten im unten stehenden Umfang und für die dort genannten Zwecke durch den Verantwortlichen ein. Dabei gelten folgenden Bedingungen, die nach der EU-Datenschutzgrundverordnung (EU-DSGVO) zu gewährleisten sind.</p>

        <h2>1. PERSONEN </h2>

        <p>Verantwortlich im Sinne der Datenschutzgrundverordnung und anderer nationaler Datenschutzgesetze der EU-Mitgliedstaaten sowie sonstiger datenschutzrechtlicher Bestimmungen ist die:</p>

        <p>Universität Hamburg</p>

        <p>Mittelweg 177</p>

        <p>20148 Hamburg</p>

        <p>Tel.: +49 40 42838-0</p>

        <p>Fax.: +49 40 42838-9586</p>

        <p>Die Universität ist eine Körperschaft des Öffentlichen Rechts. Sie wird gesetzlich vertreten durch Univ.-Prof. Dr. Hauke Heekeren, Präsident der Universität Hamburg, Mittelweg 177, 20148 Hamburg.</p>

        <h3>NAME UND ANSCHRIFT DES VERTRETERS / FACHVERANTWORTLICHEN:</h3>

        <p>Prof. Dr. Thorsten Logge</p>

        <p>Fachbereich Geschichte | Public History<br />
        Universität Hamburg<br />
        Von-Melle-Park 6<br />
        20146 Hamburg<br />
        Deutschland</p>

        <p>Tel.: +49 40 42838-9061</p>

        <p>Fax: +49 40 42838-3955</p>

        <p>E-Mail: <a href="mailto:thorsten.logge@uni-hamburg.de">thorsten.logge@uni-hamburg.de</a></p>

        <h2>2. ZWECK </h2>

        <p>Meine Daten werden ausschließlich für folgenden Zweck verarbeitet:</p>

        <p>Speicherung eingereichter digitaler Dokumente (persönliche Erfahrungsberichte, Fotografien, Videoaufnahmen, Musikaufnahmen, Texte) im Zusammenhang mit Begriff Freiheit. Die Zuordnung eingereichter digitaler Objekte auf der Plattform „www.freiheitsarchiv.de“, Rückfragen durch Moderatorinnen und Moderatoren bei unklaren Datenlagen per E-Mail.</p>

        <h2>3. PERSONENBEZOGENE DATEN </h2>

        <p>Es werden folgende Daten bzw. Datenkategorien erhoben und verarbeitet: Online-Name (Alias), Vorname, Name, E-Mail-Adresse, Wohnort, objektbezogene Informationen für die interne Zuordnung der eingereichten Objekte.</p>

        <h2>4. EMPFÄNGER/ KATEGORIEN VON EMPFÄNGERN </h2>

        <h3>MEINE PERSONENBEZOGENEN DATEN WERDEN AN FOLGENDE EMPFÄNGER ÜBERMITTELT:</h3>

        <p><i>Dienstleister/Auftragsverarbeiter für die Plattform „freiheitsarchiv“</i></p>

        <p><i><a href="https://bombig.net" target="_blank" rel="noreferrer noopener">bombig.net</a><br />
        Eschholzstraße 38<br />
        79106 Freiburg im Breisgau</i></p>

        <p><i>Dies dient folgenden Zwecken: Zuordnung eingereichter digitaler Objekte, Rückfragen bei unklaren Angaben, administrative und gestalterische Aufgaben im Back-End. </i></p>

        <h2>5. DAUER DER SPEICHERUNG </h2>

        <p>Meine personenbezogenen Daten werden für folgende Dauer gespeichert:</p>

        <p><strong>10 Jahre.</strong></p>

        <p>Anschließend werden sie gelöscht bzw. so anonymisiert, dass eine Zuordnung zu meiner Person nicht mehr möglich ist.</p>

        <h2>6. MEINE RECHTE </h2>

        <h3><b>1. FREIWILLIGKEIT </b></h3>

        <p>Ich kann nicht gezwungen oder gedrängt werden, meine Einwilligung zu erklären oder aufrecht zu erhalten.</p>

        <h3>2. WIDERRUFSRECHT </h3>

        <p>Ich kann jederzeit meine Einwilligung mit Wirkung für die Zukunft widerrufen. Dies kann mündlich oder per E-Mail erfolgen. Gegebenenfalls muss ich meine Identität nachweisen. Ab Zugang der Erklärung dürfen meine Daten nicht weiterverarbeitet werden. Sie sind unverzüglich zu löschen. Die bisherige Verarbeitung bleibt jedoch hiervon unberührt.</p>

        <h3>3. Auskunftsrecht </h3>

        <p>Ich habe nach Art. 15 EU-DSGVO ein Auskunftsrecht gegenüber dem Verantwortlichen.</p>

        <h2>7. RECHT AUF BERICHTIGUNG </h2>

        <p>Ich kann nach Art. 16 EU-DSGVO die Berichtigung fehlerhafter Daten vom Verantwortlichen verlangen.</p>

        <h3>1. LÖSCHUNG </h3>

        <p>Ich habe ein Recht auf Löschung meiner personenbezogenen Daten bzw. ein „Recht auf Vergessenwerden“ nach Art. 17 EU-DSGVO gegenüber dem Verantwortlichen.</p>

        <h3>2. EINSCHRÄNKUNG DER VERARBEITUNG</h3>

        <p>Ich habe das Recht, vom Verantwortlichen die Einschränkung der Verarbeitung meiner personenbezogenen Daten nach Art. 18 EU-DSGVO zu verlangen.</p>

        <h3>3. BESCHWERDERECHT</h3>

        <p>Ich habe das Recht, Beschwerde gegen die Verarbeitung meiner personenbezogenen Daten beim Hamburgischen Beauftragten für Datenschutz und Informationsfreiheit zu erheben.</p>
        </body>
        </html>
        """
    }
    
    
    func loadCondition() -> String {
        return """
        <html>
        <head>
        <style>
            body {
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                font-size: 20px; /* Increased base font size from default to 20px */
                line-height: 1.6;
            }
            h1 {
                font-size: 24px; /* Increased heading 1 font size */
                margin-top: 20px;
            }
            h2 {
                font-size: 22px; /* Increased heading 2 font size */
            }
            h3 {
                font-size: 21px; /* Increased heading 3 font size */
            }
            p {
                margin-top: 10px;
            }
        </style>
        </head>
        <body>
        <h1>Einreichbedingungen</h1>

        <p>(1) Meine Kontaktdaten werden nicht veröffentlicht und dienen ausschließlich zur Bearbeitung des von mir bereitgestellten Materials.</p>

        <p>(2) Ich bin damit einverstanden, dass ich bei Rückfragen zu meinem Material ggf. über meine E-Mail-Adresse kontaktiert werde.</p>

        <p>(3) Mir ist bewusst, dass das eingereichte Material moderiert und ggf. veröffentlicht wird. Es besteht kein Recht auf eine Veröffentlichung.<br />
        Strafbare Inhalte werden nicht veröffentlicht und ggf. zur Anzeige gebracht.</p>

        <p>(4) Das von mir hochgeladene Material verletzt keine Urheber- und Persönlichkeitsrechte Dritter.</p>

        <p>(5) Ich stelle weiterhin das digitale Archiv „freiheitsarchiv“ von jeglichen Ansprüchen und Verbindlichkeiten frei, die sich aus der Nutzung des Materials durch das Archiv ergeben, einschließlich und ohne Einschränkung auch von Ansprüchen Dritter wegen Verletzung von Persönlichkeitsrechten, der Privatsphäre, Verleumdung oder falscher Darstellung von Tatsachen sowie Urheberrechtsverletzungen.</p>

        <p>(6) Mit der Einreichung von Material gebe ich die Erlaubnis und das Einverständnis zur Verbreitung und Nutzung in Verbindung mit dem digitalen Archiv „freiheitsarchiv“.</p>

        <p>(7) Ich bin volljährig. Wenn ich minderjährig bin, habe ich das Einverständnis meiner Eltern eingeholt.</p>
        </body>
        </html>
        """
    }
    
    
    func loadGdpr() -> String {
        return """
        <html>
        <head>
        <style>
            body {
                color: white;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
                font-size: 20px; /* Increased base font size from default to 20px */
                line-height: 1.6;
            }
            h1 {
                font-size: 24px; /* Increased heading 1 font size */
                margin-top: 20px;
            }
            h2 {
                font-size: 22px; /* Increased heading 2 font size */
            }
            h3 {
                font-size: 21px; /* Increased heading 3 font size */
            }
            p {
                margin-top: 10px;
            }
        </style>
        </head>
        <body>
        <h1>DATENSCHUTZERKLÄRUNG NACH DER DSGVO</h1>

        <h2>I. Name und Anschrift des Verantwortlichen</h2>

        <p>Verantwortlich im Sinne der Datenschutzgrundverordnung und anderer nationaler Datenschutzgesetze der EU-Mitgliedstaaten sowie sonstiger datenschutzrechtlicher Bestimmungen ist die:<br />
         </p>

        <p>Universität Hamburg<br />
        Mittelweg 177<br />
        20148 Hamburg<br />
        Tel.: +49 40 42838-0<br />
        Fax.: +49 40 42838-9586</p>

        <p>Die Universität ist eine Körperschaft des Öffentlichen Rechts. Sie wird gesetzlich vertreten durch Univ.-Prof. Dr. Hauke Heekeren,</p>

        <p>Präsident der Universität Hamburg,</p>

        <p>Mittelweg 177, 20148 Hamburg.</p>

        <p> </p>

        <h3>NAME UND ANSCHRIFT DES VERTRETERS / FACHVERANTWORTLICHEN:</h3>

        <p>Prof. Dr. Thorsten Logge</p>

        <p>Fachbereich Geschichte | Public History<br />
        Universität Hamburg<br />
        Von-Melle-Park 6<br />
        20146 Hamburg<br />
        Deutschland</p>

        <p>Tel.: +49 40 42838-9061</p>

        <p>Fax: +49 40 42838-3955</p>

        <p><i>thorsten.logge@uni-hamburg.de </i></p>

        <h2>II. Name und Anschrift des Datenschutzbeauftragten</h2>

        <p>Der Datenschutzbeauftragte des Verantwortlichen ist:<br />
        Datenschutzbeauftrager der Universität Hamburg<br />
        Mittelweg 177<br />
        20148 Hamburg<br />
        Deutschland<br />
        E-Mail: datenschutz@uni-hamburg.de</p>

        <h2><br />
        III. Allgemeines zur Datenverarbeitung</h2>

        <h3>1. UMFANG DER VERARBEITUNG PERSONENBEZOGENER DATEN</h3>

        <p>Wir verarbeiten personenbezogene Daten unserer Nutzer grundsätzlich nur, soweit dies zur Bereitstellung einer funktionsfähigen Website sowie unserer Inhalte und Leistungen erforderlich ist. Die Verarbeitung personenbezogener Daten unserer Nutzer erfolgt regelmäßig nur nach Einwilligung des Nutzers. Eine Ausnahme gilt in solchen Fällen, in denen eine vorherige Einholung einer Einwilligung aus tatsächlichen Gründen nicht möglich ist und die Verarbeitung der Daten durch gesetzliche Vorschriften gestattet ist.</p>

        <h3>2. RECHTSGRUNDLAGE FÜR DIE VERARBEITUNG PERSONENBEZOGENER DATEN</h3>

        <p>Soweit wir für Verarbeitungsvorgänge personenbezogener Daten eine Einwilligung der betroffenen Person einholen, dient Art. 6 Abs. 1 lit. a EU-Datenschutzgrundverordnung (DSGVO) als Rechtsgrundlage.<br />
        Bei der Verarbeitung von personenbezogenen Daten, die zur Erfüllung eines Vertrages, dessen Vertragspartei die betroffene Person ist, erforderlich ist, dient Art. 6 Abs. 1 lit. b DSGVO als Rechtsgrundlage. Dies gilt auch für Verarbeitungsvorgänge, die zur Durchführung vorvertraglicher Maßnahmen erforderlich sind.<br />
        Soweit eine Verarbeitung personenbezogener Daten zur Erfüllung einer rechtlichen Verpflichtung erforderlich ist, der unser Unternehmen unterliegt, dient Art. 6 Abs. 1 lit. c  DSGVO als Rechtsgrundlage.<br />
        Für den Fall, dass lebenswichtige Interessen der betroffenen Person oder einer anderen natürlichen Person eine Verarbeitung personenbezogener Daten erforderlich machen, dient Art. 6 Abs. 1 lit. d DSGVO als Rechtsgrundlage.<br />
        Ist die Verarbeitung zur Wahrung eines berechtigten Interesses unseres Unternehmens oder eines Dritten erforderlich und überwiegen die Interessen, Grundrechte und Grundfreiheiten des Betroffenen das erstgenannte Interesse nicht, so dient Art. 6 Abs. 1 lit. f DSGVO als Rechtsgrundlage für die Verarbeitung.</p>

        <h3>3. DATENLÖSCHUNG UND SPEICHERDAUER</h3>

        <p>Die personenbezogenen Daten der betroffenen Person werden gelöscht oder gesperrt, sobald der Zweck der Speicherung entfällt. Eine Speicherung kann darüber hinaus erfolgen, wenn dies durch den europäischen oder nationalen Gesetzgeber in unionsrechtlichen Verordnungen, Gesetzen oder sonstigen Vorschriften, denen der Verantwortliche unterliegt, vorgesehen wurde. Eine Sperrung oder Löschung der Daten erfolgt auch dann, wenn eine durch die genannten Normen vorgeschriebene Speicherfrist abläuft, es sei denn, dass eine Erforderlichkeit zur weiteren Speicherung der Daten für einen Vertragsabschluss oder eine Vertragserfüllung besteht.</p>

        <h2>IV. Bereitstellung der Website und Erstellung von Logfiles</h2>

        <h3>1. BESCHREIBUNG UND UMFANG DER DATENVERARBEITUNG</h3>

        <p>Bei jedem Aufruf unserer Internetseite erfasst unser System automatisiert Daten und Informationen vom Computersystem des aufrufenden Rechners.<br />
        Folgende Daten werden hierbei erhoben:</p>

        <p>(1) Informationen über den Browsertyp und die verwendete Version<br />
        (2) Das Betriebssystem des Nutzers<br />
        (3) Den Internet-Service-Provider des Nutzers<br />
        (4) Die IP-Adresse des Nutzers<br />
        (5) Datum und Uhrzeit des Zugriffs<br />
        (6) Websites, von denen das System des Nutzers auf unsere Internetseite gelangt <br />
        (7) Websites, die vom System des Nutzers über unsere Website aufgerufen werden.</p>

        <p>Die Daten werden ebenfalls in den Logfiles unseres Systems gespeichert. Eine Speicherung dieser Daten zusammen mit anderen personenbezogenen Daten des Nutzers findet nicht statt.</p>

        <h3>2. RECHTSGRUNDLAGE FÜR DIE DATENVERARBEITUNG</h3>

        <p>Rechtsgrundlage für die vorübergehende Speicherung der Daten und der Logfiles ist Art. 6 Abs. 1 lit. f DSGVO.</p>

        <h3>3. ZWECK DER DATENVERARBEITUNG</h3>

        <p>Die vorübergehende Speicherung der IP-Adresse durch das System ist notwendig, um eine Auslieferung der Website an den Rechner des Nutzers zu ermöglichen. Hierfür muss die IP- Adresse des Nutzers für die Dauer der Sitzung gespeichert bleiben. Die Speicherung in Logfiles erfolgt, um die Funktionsfähigkeit der Website sicherzustellen. Zudem dienen uns die Daten zur Optimierung der Website und zur Sicherstellung der Sicherheit unserer informationstechnischen Systeme. Eine Auswertung der Daten zu Marketingzwecken findet in diesem Zusammenhang nicht statt. In diesen Zwecken liegt auch unser berechtigtes Interesse an der Datenverarbeitung nach Art. 6 Abs. 1 lit. f DSGVO.</p>

        <h3>4. DAUER DER SPEICHERUNG</h3>

        <p>Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr erforderlich sind. Im Falle der Erfassung der Daten zur Bereitstellung der Website ist dies der Fall, wenn die jeweilige Sitzung beendet ist. Im Falle der Speicherung der Daten in Logfiles ist dies nach spätestens sieben Tagen der Fall. Eine darüberhinausgehende Speicherung ist möglich. In diesem Fall werden die IP-Adressen der Nutzer gelöscht oder verfremdet, sodass eine Zuordnung des aufrufenden Clients nicht mehr möglich ist.</p>

        <h3>5. WIDERSPRUCHS- UND BESEITIGUNGSMÖGLICHKEIT</h3>

        <p>Die Erfassung der Daten zur Bereitstellung der Website und die Speicherung der Daten in Logfiles ist für den Betrieb der Internetseite zwingend erforderlich. Es besteht folglich seitens des Nutzers keine Widerspruchsmöglichkeit.</p>

        <h2>V. Verwendung von Cookies</h2>

        <h3>A) BESCHREIBUNG UND UMFANG DER DATENVERARBEITUNG</h3>

        <p>Unsere Webseite verwendet Cookies. Bei Cookies handelt es sich um Textdateien, die im Internetbrowser bzw. vom Internetbrowser auf dem Computersystem des Nutzers gespeichert werden. Ruft ein Nutzer eine Website auf, so kann ein Cookie auf dem Betriebssystem des Nutzers gespeichert werden. Dieser Cookie enthält eine charakteristische Zeichenfolge, die eine eindeutige Identifizierung des Browsers beim erneuten Aufrufen der Website ermöglicht.<br />
        Wir setzen Cookies ein, um unsere Website nutzerfreundlicher zu gestalten. Einige Elemente unserer Internetseite erfordern es, dass der aufrufende Browser auch nach einem Seitenwechsel identifiziert werden kann.</p>

        <h3>B) RECHTSGRUNDLAGE FÜR DIE DATENVERARBEITUNG</h3>

        <p>Die Rechtsgrundlage für die Verarbeitung personenbezogener Daten unter Verwendung von Cookies ist Art. 6 Abs. 1 lit. f DSGVO.</p>

        <h3>C) ZWECK DER DATENVERARBEITUNG</h3>

        <p>Der Zweck der Verwendung technisch notwendiger Cookies ist, die Nutzung von Websites für die Nutzer zu vereinfachen. Einige Funktionen unserer Internetseite können ohne den Einsatz von Cookies nicht angeboten werden. Für diese ist es erforderlich, dass der Browser auch nach einem Seitenwechsel wiedererkannt wird.<br />
        In diesen Zwecken liegt auch unser berechtigtes Interesse in der Verarbeitung der personenbezogenen Daten nach Art. 6 Abs. 1 lit. f DSGVO</p>

        <h3>E) DAUER DER SPEICHERUNG, WIDERSPRUCHS- UND BESEITIGUNGSMÖGLICHKEIT</h3>

        <p>Cookies werden auf dem Rechner des Nutzers gespeichert und von diesem an unserer Seite übermittelt. Daher haben Sie als Nutzer auch die volle Kontrolle über die Verwendung von Cookies. Durch eine Änderung der Einstellungen in Ihrem Internetbrowser können Sie die Übertragung von Cookies deaktivieren oder einschränken. Bereits gespeicherte Cookies können jederzeit gelöscht werden. Dies kann auch automatisiert erfolgen. Werden Cookies für unsere Website deaktiviert, können möglicherweise nicht mehr alle Funktionen der<br />
        Website vollumfänglich genutzt werden. Die Übermittlung von Flash-Cookies lässt sich nicht über die Einstellungen des Browsers, jedoch durch Änderungen der Einstellung des Flash Players unterbinden.</p>

        <h2>VI. Webanalyse</h2>

        <h3>1) MATOMO</h3>

        <p>Die Webseite benutzt Matomo, eine Open-Source-Software zur Analyse und statistischen Auswertung der Besucherzugriffe.<br />
        Matomo verwendet sogenannte „Cookies“, Textdateien, die auf Ihrem Computer gespeichert werden und die eine Analyse der Benutzung der Website durch Sie ermöglichen. Die durch den Cookie erzeugten Informationen über Ihre Benutzung dieses Internetangebotes werden auf einem Server der Universität Hamburg in Deutschland gespeichert. Die IP-Adresse wird sofort nach der Verarbeitung und vor deren Speicherung anonymisiert.<br />
        Die Informationen werden verwendet, um die Nutzung der Website auszuwerten und um eine bedarfsgerechte Gestaltung der Website zu ermöglichen. Rechtsgrundlage für die Verarbeitung der Daten ist Art. 6 Abs. 1 lit. f DSGVO.<br />
        Sie können die Installation der Cookies auch durch eine entsprechende Einstellung Ihrer Browser-Software verhindern; wir weisen Sie jedoch darauf hin, dass Sie in diesem Fall gegebenenfalls nicht sämtliche Funktionen dieser Website vollumfänglich nutzen können.</p>

        <h2>VII. Registrierung</h2>

        <h3>1. BESCHREIBUNG UND UMFANG DER DATENVERARBEITUNG</h3>

        <p>Auf unserer Internetseite bieten wir Nutzern die Möglichkeit, sich unter Angabe personenbezogener Daten zu registrieren. Die Daten werden dabei in eine Eingabemaske eingegeben und an uns übermittelt und gespeichert. Eine Weitergabe der Daten an Dritte findet nicht statt. Folgende Daten werden im Rahmen des Registrierungsprozesses erhoben: Im Zeitpunkt der Registrierung werden zudem folgende Daten gespeichert</p>

        <p>(1) Die IP-Adresse des Nutzers<br />
        (2) Datum und Uhrzeit der Registrierung</p>

        <p>Im Rahmen des Registrierungsprozesses wird eine Einwilligung des Nutzers zur Verarbeitung dieser Daten eingeholt.</p>

        <h3>2. RECHTSGRUNDLAGE FÜR DIE DATENVERARBEITUNG</h3>

        <p>Rechtsgrundlage für die Verarbeitung der Daten ist bei Vorliegen einer Einwilligung des Nutzers Art. 6 Abs. 1 lit. a DSGVO.</p>

        <h3>3. ZWECK DER DATENVERARBEITUNG</h3>

        <p>Eine Registrierung des Nutzers ist für das Bereithalten bestimmter Inhalte und Leistungen auf unserer Website erforderlich. Eine Registrierung des Nutzers ist zur Erfüllung eines Vertrages mit dem Nutzer oder zur Durchführung vorvertraglicher Maßnahmen erforderlich.</p>

        <h3>4. DAUER DER SPEICHERUNG</h3>

        <p>Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr erforderlich sind.<br />
        Dies ist für die während des Registrierungsvorgangs erhobenen Daten der Fall, wenn die Registrierung auf unserer Internetseite aufgehoben oder abgeändert wird.</p>

        <h3>5. WIDERSPRUCHS- UND BESEITIGUNGSMÖGLICHKEIT</h3>

        <p>Als Nutzer haben sie jederzeit die Möglichkeit, die Registrierung aufzulösen. Die über Sie gespeicherten Daten können Sie jederzeit abändern lassen.</p>

        <h2>VIII. Kontaktformular und E-Mail-Kontakt</h2>

        <h3>1. BESCHREIBUNG UND UMFANG DER DATENVERARBEITUNG</h3>

        <p>Auf unserer Internetseite ist ein Kontaktformular vorhanden, welches für die elektronische Kontaktaufnahme genutzt werden kann. Nimmt ein Nutzer diese Möglichkeit wahr, so werden die in der Eingabemaske eingegeben Daten an uns übermittelt und gespeichert. Diese Daten sind:<br />
        Im Zeitpunkt der Absendung der Nachricht werden zudem folgende Daten gespeichert:</p>

        <p>(1) Die IP-Adresse des Nutzers<br />
        (2) Datum und Uhrzeit der Registrierung</p>

        <p>Für die Verarbeitung der Daten wird im Rahmen des Absendevorgangs Ihre Einwilligung eingeholt und auf diese Datenschutzerklärung verwiesen.<br />
        Alternativ ist eine Kontaktaufnahme über die bereitgestellte E-Mail-Adresse möglich. In diesem Fall werden die mit der E-Mail übermittelten personenbezogenen Daten des Nutzers gespeichert.</p>

        <p>Es erfolgt in diesem Zusammenhang keine Weitergabe der Daten an Dritte. Die Daten werden ausschließlich für die Verarbeitung der Konversation verwendet.</p>

        <h3><span style="font-size:12pt;"><span style="font-family:Aptos, sans-serif;">2. RECHTSGRUNDLAGE FÜR DIE DATENVERARBEITUNG </span></span></h3>

        <p>Rechtsgrundlage für die Verarbeitung der Daten ist bei Vorliegen einer Einwilligung des Nutzers Art. 6 Abs. 1 lit. a DSGVO.<br />
        Rechtsgrundlage für die Verarbeitung der Daten, die im Zuge einer Übersendung einer E- Mail übermittelt werden, ist Art. 6 Abs. 1 lit. f DSGVO. Zielt der E-Mail-Kontakt auf den Abschluss eines Vertrages ab, so ist zusätzliche Rechtsgrundlage für die Verarbeitung Art. 6 Abs. 1 lit. b DSGVO.</p>

        <h3><span style="font-size:12pt;"><span style="font-family:Aptos, sans-serif;">3. ZWECK DER DATENVERARBEITUNG </span></span></h3>

        <p>Die Verarbeitung der personenbezogenen Daten aus der Eingabemaske dient uns allein zur Bearbeitung der Kontaktaufnahme. Im Falle einer Kontaktaufnahme per E-Mail liegt hieran auch das erforderliche berechtigte Interesse an der Verarbeitung der Daten.<br />
        Die sonstigen während des Absendevorgangs verarbeiteten personenbezogenen Daten dienen dazu, einen Missbrauch des Kontaktformulars zu verhindern und die Sicherheit unserer informationstechnischen Systeme sicherzustellen.</p>

        <h3>4. DAUER DER SPEICHERUNG</h3>

        <p>Die Daten werden gelöscht, sobald sie für die Erreichung des Zweckes ihrer Erhebung nicht mehr erforderlich sind. Für die personenbezogenen Daten aus der Eingabemaske des Kontaktformulars und diejenigen, die per E-Mail übersandt wurden, ist dies dann der Fall, wenn die jeweilige Konversation mit dem Nutzer beendet ist. Beendet ist die Konversation dann, wenn sich aus den Umständen entnehmen lässt, dass der betroffene Sachverhalt abschließend geklärt ist.<br />
        Die während des Absendevorgangs zusätzlich erhobenen personenbezogenen Daten werden spätestens nach einer Frist von sieben Tagen gelöscht.</p>

        <h3><b>5. WIDERSPRUCHS- UND BESEITIGUNGSMÖGLICHKEIT </b></h3>

        <p>Der Nutzer hat jederzeit die Möglichkeit, seine Einwilligung zur Verarbeitung der personenbezogenen Daten zu widerrufen. Nimmt der Nutzer per E-Mail Kontakt mit uns auf, so kann er der Speicherung seiner personenbezogenen Daten jederzeit widersprechen. In einem solchen Fall kann die Konversation nicht fortgeführt werden.<br />
        Alle personenbezogenen Daten, die im Zuge der Kontaktaufnahme gespeichert wurden, werden in diesem Fall gelöscht.</p>

        <h2>VIII. Rechte der betroffenen Person</h2>

        <p>Werden personenbezogene Daten von Ihnen verarbeitet, sind Sie Betroffener i.S.d. DSGVO und es stehen Ihnen folgende Rechte gegenüber dem Verantwortlichen zu:</p>

        <h3><b>1. AUSKUNFTSRECHT </b></h3>

        <p>Sie können von dem Verantwortlichen eine Bestätigung darüber verlangen, ob personenbezogene Daten, die Sie betreffen, von uns verarbeitet werden.<br />
        Liegt eine solche Verarbeitung vor, können Sie von dem Verantwortlichen über folgende Informationen Auskunft verlangen:</p>

        <p>(1) die Zwecke, zu denen die personenbezogenen Daten verarbeitet werden;<br />
        (2) die Kategorien von personenbezogenen Daten, welche verarbeitet werden;<br />
        (3) die Empfänger bzw. die Kategorien von Empfängern, gegenüber denen die Sie betreffenden personenbezogenen Daten offengelegt wurden oder noch offengelegt werden;<br />
        (4) die geplante Dauer der Speicherung der Sie betreffenden personenbezogenen Daten oder, falls konkrete Angaben hierzu nicht möglich sind, Kriterien für die Festlegung der Speicherdauer;<br />
        (5) das Bestehen eines Rechts auf Berichtigung oder Löschung der Sie betreffenden personenbezogenen Daten, eines Rechts auf Einschränkung der Verarbeitung durch den Verantwortlichen oder eines Widerspruchsrechts gegen diese Verarbeitung;<br />
        (6) das Bestehen eines Beschwerderechts bei einer Aufsichtsbehörde;<br />
        (7) alle verfügbaren Informationen über die Herkunft der Daten, wenn die personenbezogenen Daten nicht bei der betroffenen Person erhoben werden;<br />
        (8) das Bestehen einer automatisierten Entscheidungsfindung einschließlich Profiling gemäß Art.22 Abs.1 und 4 DSGVO und – zumindest in diesen Fällen – aussagekräftige Informationen über die involvierte Logik sowie die Tragweite und die angestrebten Auswirkungen einer derartigen Verarbeitung für die betroffene Person.<br />
        Ihnen steht das Recht zu, Auskunft darüber zu verlangen, ob die Sie betreffenden personenbezogenen Daten in ein Drittland oder an eine internationale Organisation übermittelt werden. In diesem Zusammenhang können Sie verlangen, über die geeigneten Garantien gem. Art. 46 DSGVO im Zusammenhang mit der Übermittlung unterrichtet zu werden.</p>

        <h3><b>2. RECHT AUF BERICHTIGUNG </b></h3>

        <p>Sie haben ein Recht auf Berichtigung und/oder Vervollständigung gegenüber dem Verantwortlichen, sofern die verarbeiteten personenbezogenen Daten, die Sie betreffen, unrichtig oder unvollständig sind. Der Verantwortliche hat die Berichtigung unverzüglich vorzunehmen.</p>

        <h3><b>3. RECHT AUF EINSCHRÄNKUNG DER VERARBEITUNG </b></h3>

        <p>Unter den folgenden Voraussetzungen können Sie die Einschränkung der Verarbeitung der Sie betreffenden personenbezogenen Daten verlangen:</p>

        <p>(1) wenn Sie die Richtigkeit der Sie betreffenden personenbezogenen für eine Dauer bestreiten, die es dem Verantwortlichen ermöglicht, die Richtigkeit der personenbezogenen Daten zu überprüfen;<br />
        (2) die Verarbeitung unrechtmäßig ist und Sie die Löschung der personenbezogenen Daten ablehnen und stattdessen die Einschränkung der Nutzung der personenbezogenen Daten verlangen;<br />
        (3) der Verantwortliche die personenbezogenen Daten für die Zwecke der Verarbeitung nicht länger benötigt, Sie diese jedoch zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen benötigen, oder<br />
        (4) wenn Sie Widerspruch gegen die Verarbeitung gemäß Art. 21 Abs. 1 DSGVO eingelegt haben und noch nicht feststeht, ob die berechtigten Gründe des Verantwortlichen gegenüber Ihren Gründen überwiegen.</p>

        <p>Wurde die Verarbeitung der Sie betreffenden personenbezogenen Daten eingeschränkt, dürfen diese Daten – von ihrer Speicherung abgesehen – nur mit Ihrer Einwilligung oder zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen oder zum Schutz der Rechte einer anderen natürlichen oder juristischen Person oder aus Gründen eines wichtigen öffentlichen Interesses der Union oder eines Mitgliedstaats verarbeitet werden.</p>

        <p>Wurde die Einschränkung der Verarbeitung nach den o.g. Voraussetzungen eingeschränkt, werden Sie von dem Verantwortlichen unterrichtet bevor die Einschränkung aufgehoben wird.</p>

        <h3><b>4. RECHT AUF LÖSCHUNG </b></h3>

        <p><b><span style="font-family:Arial, sans-serif;">a) Löschungspflicht </span></b></p>

        <p>Sie können von dem Verantwortlichen verlangen, dass die Sie betreffenden personenbezogenen Daten unverzüglich gelöscht werden, und der Verantwortliche ist verpflichtet, diese Daten unverzüglich zu löschen, sofern einer der folgenden Gründe zutrifft:</p>

        <p>(1) Die Sie betreffenden personenbezogenen Daten sind für die Zwecke, für die sie erhoben oder auf sonstige Weise verarbeitet wurden, nicht mehr notwendig.<br />
        (2) Sie widerrufen Ihre Einwilligung, auf die sich die Verarbeitung gem. Art. 6 Abs. 1 lit. a oder Art. 9 Abs. 2 lit. a DSGVO stützte, und es fehlt an einer anderweitigen Rechtsgrundlage für die Verarbeitung.<br />
        (3) Sie legen gem. Art. 21 Abs. 1 DSGVO Widerspruch gegen die Verarbeitung ein und es liegen keine vorrangigen berechtigten Gründe für die Verarbeitung vor, oder Sie legen gem. Art. 21 Abs. 2 DSGVO Widerspruch gegen die Verarbeitung ein.<br />
        (4) Die Sie betreffenden personenbezogenen Daten wurden unrechtmäßig verarbeitet.<br />
        (5) Die Löschung der Sie betreffenden personenbezogenen Daten ist zur Erfüllung einer rechtlichen Verpflichtung nach dem Unionsrecht oder dem Recht der Mitgliedstaaten erforderlich, dem der Verantwortliche unterliegt.<br />
        (6) Die Sie betreffenden personenbezogenen Daten wurden in Bezug auf angebotene Dienste der Informationsgesellschaft gemäß Art. 8 Abs. 1 DSGVO erhoben.</p>

        <p><b><span style="font-family:Arial, sans-serif;">b) Information an Dritte </span></b></p>

        <p>Hat der Verantwortliche die Sie betreffenden personenbezogenen Daten öffentlich gemacht und ist er gem. Art. 17 Abs. 1 DSGVO zu deren Löschung verpflichtet, so trifft er unter Berücksichtigung der verfügbaren Technologie und der Implementierungskosten angemessene Maßnahmen, auch technischer Art, um für die Datenverarbeitung Verantwortliche, die die personenbezogenen Daten verarbeiten, darüber zu informieren, dass Sie als betroffene Person von ihnen die Löschung aller Links zu diesen personenbezogenen Daten oder von Kopien oder Replikationen dieser personenbezogenen Daten verlangt haben.</p>

        <p><b><span style="font-family:Arial, sans-serif;">c) Ausnahmen </span></b></p>

        <p>Das Recht auf Löschung besteht nicht, soweit die Verarbeitung erforderlich ist</p>

        <p>(1) zur Ausübung des Rechts auf freie Meinungsäußerung und Information;<br />
        (2) zur Erfüllung einer rechtlichen Verpflichtung, die die Verarbeitung nach dem Recht der Union oder der Mitgliedstaaten, dem der Verantwortliche unterliegt, erfordert, oder zur Wahrnehmung einer Aufgabe, die im öffentlichen Interesse liegt oder in Ausübung öffentlicher Gewalt erfolgt, die dem Verantwortlichen übertragen wurde;<br />
        (3) aus Gründen des öffentlichen Interesses im Bereich der öffentlichen Gesundheit gemäß Art. 9 Abs. 2 lit. h und i sowie Art. 9 Abs. 3 DSGVO;<br />
        (4) für im öffentlichen Interesse liegende Archivzwecke, wissenschaftliche oder historische Forschungszwecke oder für statistische Zwecke gem. Art. 89 Abs. 1 DSGVO, soweit das unter Abschnitt a) genannte Recht voraussichtlich die Verwirklichung der Ziele dieser Verarbeitung unmöglich macht oder ernsthaft beeinträchtigt, oder<br />
        (5) zur Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen.</p>

        <h3><b>5. RECHT AUF UNTERRICHTUNG </b></h3>

        <p>Haben Sie das Recht auf Berichtigung, Löschung oder Einschränkung der Verarbeitung gegenüber dem Verantwortlichen geltend gemacht, ist dieser verpflichtet, allen Empfängern, denen die Sie betreffenden personenbezogenen Daten offengelegt wurden, diese Berichtigung oder Löschung der Daten oder Einschränkung der Verarbeitung mitzuteilen, es sei denn, dies erweist sich als unmöglich oder ist mit einem unverhältnismäßigen Aufwand verbunden.<br />
        Ihnen steht gegenüber dem Verantwortlichen das Recht zu, über diese Empfänger unterrichtet zu werden.</p>

        <h3><b>6. RECHT AUF DATENÜBERTRAGBARKEIT </b></h3>

        <p>Sie haben das Recht, die Sie betreffenden personenbezogenen Daten, die Sie dem Verantwortlichen bereitgestellt haben, in einem strukturierten, gängigen und maschinenlesbaren Format zu erhalten. Außerdem haben Sie das Recht diese Daten einem anderen Verantwortlichen ohne Behinderung durch den Verantwortlichen, dem die personenbezogenen Daten bereitgestellt wurden, zu übermitteln, sofern</p>

        <p>(1) die Verarbeitung auf einer Einwilligung gem. Art. 6 Abs. 1 lit. a DSGVO oder Art. 9 Abs. 2 lit. a DSGVO oder auf einem Vertrag gem. Art. 6 Abs. 1 lit. b DSGVO beruht und<br />
        (2) die Verarbeitung mithilfe automatisierter Verfahren erfolgt.</p>

        <p>In Ausübung dieses Rechts haben Sie ferner das Recht, zu erwirken, dass die Sie betreffenden personenbezogenen Daten direkt von einem Verantwortlichen einem anderen Verantwortlichen übermittelt werden, soweit dies technisch machbar ist. Freiheiten und Rechte anderer Personen dürfen hierdurch nicht beeinträchtigt werden.<br />
        Das Recht auf Datenübertragbarkeit gilt nicht für eine Verarbeitung personenbezogener Daten, die für die Wahrnehmung einer Aufgabe erforderlich ist, die im öffentlichen Interesse liegt oder in Ausübung öffentlicher Gewalt erfolgt, die dem Verantwortlichen übertragen wurde.</p>

        <h3><b>7. WIDERSPRUCHSRECHT </b></h3>

        <p>Sie haben das Recht, aus Gründen, die sich aus ihrer besonderen Situation ergeben, jederzeit gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten, die aufgrund von Art. 6 Abs. 1 lit. e oder f DSGVO erfolgt, Widerspruch einzulegen; dies gilt auch für ein auf diese Bestimmungen gestütztes Profiling.</p>

        <p>Der Verantwortliche verarbeitet die Sie betreffenden personenbezogenen Daten nicht mehr, es sei denn, er kann zwingende schutzwürdige Gründe für die Verarbeitung nachweisen, die Ihre Interessen, Rechte und Freiheiten überwiegen, oder die Verarbeitung dient der Geltendmachung, Ausübung oder Verteidigung von Rechtsansprüchen.</p>

        <p>Werden die Sie betreffenden personenbezogenen Daten verarbeitet, um Direktwerbung zu betreiben, haben Sie das Recht, jederzeit Widerspruch gegen die Verarbeitung der Sie betreffenden personenbezogenen Daten zum Zwecke derartiger Werbung einzulegen; dies gilt auch für das Profiling, soweit es mit solcher Direktwerbung in Verbindung steht.</p>

        <p>Widersprechen Sie der Verarbeitung für Zwecke der Direktwerbung, so werden die Sie betreffenden personenbezogenen Daten nicht mehr für diese Zwecke verarbeitet.<br />
        Sie haben die Möglichkeit, im Zusammenhang mit der Nutzung von Diensten der Informationsgesellschaft – ungeachtet der Richtlinie 2002/58/EG – Ihr Widerspruchsrecht mittels automatisierter Verfahren auszuüben, bei denen technische Spezifikationen verwendet werden.</p>

        <p>Sie haben auch das Recht, aus Gründen, die sich aus Ihrer besonderen Situation ergeben, bei der Verarbeitung Sie betreffender personenbezogener Daten, die zu wissenschaftlichen oder historischen Forschungszwecken oder zu statistischen Zwecken gem. Art. 89 Abs. 1 DSGVO erfolgt, dieser zu widersprechen.</p>

        <p>Ihr Widerspruchsrecht kann insoweit beschränkt werden, als es voraussichtlich die Verwirklichung der Forschungs- oder Statistikzwecke unmöglich macht oder ernsthaft beeinträchtigt und die Beschränkung für die Erfüllung der Forschungs- oder Statistikzwecke notwendig ist.</p>

        <h3><b>8. RECHT AUF WIDERRUF DER DATENSCHUTZRECHTLICHEN EINWILLIGUNGSERKLÄRUNG </b></h3>

        <p>Sie haben das Recht, Ihre datenschutzrechtliche Einwilligungserklärung jederzeit zu widerrufen. Durch den Widerruf der Einwilligung wird die Rechtmäßigkeit der aufgrund der Einwilligung bis zum Widerruf erfolgten Verarbeitung nicht berührt.</p>

        <h3><b>9. AUTOMATISIERTE ENTSCHEIDUNG IM EINZELFALL EINSCHLIESSLICH PROFILING</b></h3>

        <p>Sie haben das Recht, nicht einer ausschließlich auf einer automatisierten Verarbeitung – einschließlich Profiling – beruhenden Entscheidung unterworfen zu werden, die Ihnen gegenüber rechtliche Wirkung entfaltet oder Sie in ähnlicher Weise erheblich beeinträchtigt. Dies gilt nicht, wenn die Entscheidung</p>

        <p>(1) für den Abschluss oder die Erfüllung eines Vertrags zwischen Ihnen und dem Verantwortlichen erforderlich ist,<br />
        (2) aufgrund von Rechtsvorschriften der Union oder der Mitgliedstaaten, denen der Verantwortliche unterliegt, zulässig ist und diese Rechtsvorschriften angemessene Maßnahmen zur Wahrung Ihrer Rechte und Freiheiten sowie Ihrer berechtigten Interessen enthalten oder<br />
        (3) mit Ihrer ausdrücklichen Einwilligung erfolgt.<br />
        Allerdings dürfen diese Entscheidungen nicht auf besonderen Kategorien personenbezogener Daten nach Art. 9 Abs. 1 DSGVO beruhen, sofern nicht Art. 9 Abs. 2 lit. a oder g DSGVO gilt und angemessene Maßnahmen zum Schutz der Rechte und Freiheiten sowie Ihrer berechtigten Interessen getroffen wurden.<br />
        Hinsichtlich der in (1) und (3) genannten Fälle trifft der Verantwortliche angemessene Maßnahmen, um die Rechte und Freiheiten sowie Ihre berechtigten Interessen zu wahren, wozu mindestens das Recht auf Erwirkung des Eingreifens einer Person seitens des Verantwortlichen, auf Darlegung des eigenen Standpunkts und auf Anfechtung der Entscheidung gehört.</p>

        <h3><b>10. RECHT AUF BESCHWERDE BEI EINER AUFSICHTSBEHÖRDE </b></h3>

        <p>Unbeschadet eines anderweitigen verwaltungsrechtlichen oder gerichtlichen Rechtsbehelfs steht Ihnen das Recht auf Beschwerde bei einer Aufsichtsbehörde, insbesondere in dem Mitgliedstaat ihres Aufenthaltsorts, ihres Arbeitsplatzes oder des Orts des mutmaßlichen Verstoßes, zu, wenn Sie der Ansicht sind, dass die Verarbeitung der Sie betreffenden personenbezogenen Daten gegen die DSGVO verstößt.</p>

        <p>Die Aufsichtsbehörde, bei der die Beschwerde eingereicht wurde, unterrichtet den Beschwerdeführer über den Stand und die Ergebnisse der Beschwerde einschließlich der Möglichkeit eines gerichtlichen Rechtsbehelfs nach Art. 78 DSGVO.</p>

        <h2>IX. Sicherheitsmaßnahmen</h2>

        <p>Wir treffen im Übrigen technische und organisatorische Sicherheitsmaßnahmen nach dem Stand der Technik, um die Vorschriften der Datenschutzgesetze einzuhalten und Ihre Daten gegen zufällige oder vorsätzliche Manipulationen, teilweisen oder vollständigen Verlust, Zerstörung oder gegen den unbefugten Zugriff Dritter zu schützen.</p>
        </div>
        </body>
        </html>
        """
    }
}

if not exist "publish" mkdir "publish"
flutter build windows
msix --uwp-output-path "publish\Example.msix" --bundle-id com.example.your_app --publisher-display-name Your_Publisher_Name --publisher-id CN=Some_Body

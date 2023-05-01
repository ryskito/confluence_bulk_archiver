## 使用方法
- 以下のrubyコマンドで第2引数のURLを適切なサブドメインに変更し、第3引数にアーカイブ対象の親ページのページIDを指定してください。 
- 注意: 親ページ配下の全ページがアーカイブされます（親ページはアーカイブされないため適宜手動なりでアーカイブしてください）。

```shell
ruby bulk_archive.rb 'https://{your confluence subdomain}.atlassian.net' 'parent page id'
```

### 環境変数
- CONFLUENCE_USER_NAME
  - confluenceのログインIDです。
- CONFLUENCE_API_TOKEN
  - https://id.atlassian.com/manage-profile/security/api-tokens で発行してください。
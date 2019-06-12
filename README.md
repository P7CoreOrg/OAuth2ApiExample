# OAuth2ApiExample
Simple example of using an OAuth2 token as a bearer

## Reference
The following [okta tutorial](https://developer.okta.com/blog/2018/03/23/token-authentication-aspnetcore-complete-guide) was used, but points to my authority.  

This is an out of the box ASP.NET CORE 2.2 web application where the following is added.  
```
        public void ConfigureServices(IServiceCollection services)
        {
...

            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                  
                    options.Authority = "https://graphqlplay22.azurewebsites.net/";
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        // Clock skew compensates for server time drift.
                        // We recommend 5 minutes or less:
                        ClockSkew = TimeSpan.FromMinutes(5),
                        RequireSignedTokens = true,
                        // Ensure the token hasn't expired:
                        RequireExpirationTime = true,
                        ValidateLifetime = true,
                        // Ensure the token audience matches our audience value (default true):
                        ValidateAudience = false,
                        // Ensure the token was issued by a trusted authorization server (default true):
                        ValidateIssuer = true
                   
                    };

                });
...
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
...
            app.UseAuthentication();
...
        }
```


## Request an OAuth2 Authorization Token
**https://graphqlplay22.azurewebsites.net/** is our Authority.  

```
curl -X POST \
  https://graphqlplay22.azurewebsites.net/connect/token \
  -H 'Accept: */*' \
  -H 'Authorization: Basic YXJiaXRyYXJ5LXJlc291cmNlLW93bmVyLWNsaWVudDpzZWNyZXQ=' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Host: graphqlplay22.azurewebsites.net' \
  -H 'Postman-Token: f6d03747-f979-40a4-9a4e-74d2d3be9786,aa672315-3c28-4913-9e92-32d058569eea' \
  -H 'User-Agent: PostmanRuntime/7.13.0' \
  -H 'accept-encoding: gzip, deflate' \
  -H 'cache-control: no-cache' \
  -H 'content-length: 182' \
  -H 'cookie: ARRAffinity=ead5dd93f0b7fdfb754d12ffd81cff8f6ecd08a18b7f507bf9a31c5eb623a16f' \
  -b ARRAffinity=ead5dd93f0b7fdfb754d12ffd81cff8f6ecd08a18b7f507bf9a31c5eb623a16f \
  -d 'grant_type=arbitrary_resource_owner&scope=offline_access%20wizard&arbitrary_claims=%7B%22role%22%3A%20%5B%22admin%22%2C%22limited%22%5D%7D&subject=PorkyPig&access_token_lifetime=3600'
```
## Response 
```
{
    "access_token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Imh0dHBzOi8vcDdrZXl2YWx1dC52YXVsdC5henVyZS5uZXQva2V5cy9QN0lkZW50aXR5U2VydmVyNFNlbGZTaWduZWQvZjdkODdhNDY3MDhjNGYzZDhkZmU2MTFlOTczNzQ1YzMiLCJ0eXAiOiJKV1QifQ.eyJuYmYiOjE1NjAzNjc0NDMsImV4cCI6MTU2MDM3MTA0MywiaXNzIjoiaHR0cHM6Ly9ncmFwaHFscGxheTIyLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjpbImh0dHBzOi8vZ3JhcGhxbHBsYXkyMi5henVyZXdlYnNpdGVzLm5ldC9yZXNvdXJjZXMiLCJ3aXphcmQiXSwiY2xpZW50X2lkIjoiYXJiaXRyYXJ5LXJlc291cmNlLW93bmVyLWNsaWVudCIsInN1YiI6IlBvcmt5UGlnIiwiYXV0aF90aW1lIjoxNTYwMzY3NDQzLCJpZHAiOiJsb2NhbCIsImNsaWVudF9uYW1lc3BhY2UiOiJEYWZmeSBEdWNrIiwicm9sZSI6WyJhZG1pbiIsImxpbWl0ZWQiXSwic2NvcGUiOlsid2l6YXJkIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbImFyYml0cmFyeV9yZXNvdXJjZV9vd25lciJdfQ.V_YQY3w6PC-XPhKwGj5B12BR9IsDhIKT6mXY06_iymd_Wf1mrrFvXD7lsitVUosHwWQn7PfKIxX3-dGv0BJfjXDLbVSSiCUnRMI8_7Y4OaNqtAkCV_jD0ZlhrvVqXvpd-AOFjRldu67v8OT2wGjPPPlsUG5fM-exon0lqYSu4RoOLEvZmAKsW7erj09Nxoy8Kcyu7mib-GjE0Iq_amUdcm-vPmZC5TgEFd5itCoP4OLhXlNEKhHYWcWwLcLA0as-DeMPLY8axrdaifZDNed1hFO7Qy5mMR5qgIsQdM4vumHOmin9Z3QV9qa1YeS3Z_CDiDLBeovmVmjrHdbwHvw8lA",
    "expires_in": 3600,
    "token_type": "Bearer",
    "refresh_token": "CfDJ8PIPlTwcUFFNqUfBjjZJF0_0-qj5cDpv_F8AZOiBCau22v5V5ELCKlIKMf0PU_kIW2fMdGP9G_Frhd1kvDM48gwzdN4GHwy8CUm4VU-lsswVCRoYiLWebMdRjzNz_ay0nQsoUZwiSA-r8wN6ylpud5g23HdfCpkAuoDn0BX7G67Ln16FjZqwYDrPCNTvHVO2cpadqimTnDQC5qO6fgTzOsY"
}
```
[View on jwt.io](https://jwt.io/#debugger-io?token=eyJhbGciOiJSUzI1NiIsImtpZCI6Imh0dHBzOi8vcDdrZXl2YWx1dC52YXVsdC5henVyZS5uZXQva2V5cy9QN0lkZW50aXR5U2VydmVyNFNlbGZTaWduZWQvZjdkODdhNDY3MDhjNGYzZDhkZmU2MTFlOTczNzQ1YzMiLCJ0eXAiOiJKV1QifQ.eyJuYmYiOjE1NjAzNjc0NDMsImV4cCI6MTU2MDM3MTA0MywiaXNzIjoiaHR0cHM6Ly9ncmFwaHFscGxheTIyLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjpbImh0dHBzOi8vZ3JhcGhxbHBsYXkyMi5henVyZXdlYnNpdGVzLm5ldC9yZXNvdXJjZXMiLCJ3aXphcmQiXSwiY2xpZW50X2lkIjoiYXJiaXRyYXJ5LXJlc291cmNlLW93bmVyLWNsaWVudCIsInN1YiI6IlBvcmt5UGlnIiwiYXV0aF90aW1lIjoxNTYwMzY3NDQzLCJpZHAiOiJsb2NhbCIsImNsaWVudF9uYW1lc3BhY2UiOiJEYWZmeSBEdWNrIiwicm9sZSI6WyJhZG1pbiIsImxpbWl0ZWQiXSwic2NvcGUiOlsid2l6YXJkIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbImFyYml0cmFyeV9yZXNvdXJjZV9vd25lciJdfQ.V_YQY3w6PC-XPhKwGj5B12BR9IsDhIKT6mXY06_iymd_Wf1mrrFvXD7lsitVUosHwWQn7PfKIxX3-dGv0BJfjXDLbVSSiCUnRMI8_7Y4OaNqtAkCV_jD0ZlhrvVqXvpd-AOFjRldu67v8OT2wGjPPPlsUG5fM-exon0lqYSu4RoOLEvZmAKsW7erj09Nxoy8Kcyu7mib-GjE0Iq_amUdcm-vPmZC5TgEFd5itCoP4OLhXlNEKhHYWcWwLcLA0as-DeMPLY8axrdaifZDNed1hFO7Qy5mMR5qgIsQdM4vumHOmin9Z3QV9qa1YeS3Z_CDiDLBeovmVmjrHdbwHvw8lA)  

## Make the Authorized call
```
curl -X GET \
  https://localhost:5001/api/simple/protected \
  -H 'Accept: */*' \
  -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6Imh0dHBzOi8vcDdrZXl2YWx1dC52YXVsdC5henVyZS5uZXQva2V5cy9QN0lkZW50aXR5U2VydmVyNFNlbGZTaWduZWQvZjdkODdhNDY3MDhjNGYzZDhkZmU2MTFlOTczNzQ1YzMiLCJ0eXAiOiJKV1QifQ.eyJuYmYiOjE1NjAzNjc0NDMsImV4cCI6MTU2MDM3MTA0MywiaXNzIjoiaHR0cHM6Ly9ncmFwaHFscGxheTIyLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjpbImh0dHBzOi8vZ3JhcGhxbHBsYXkyMi5henVyZXdlYnNpdGVzLm5ldC9yZXNvdXJjZXMiLCJ3aXphcmQiXSwiY2xpZW50X2lkIjoiYXJiaXRyYXJ5LXJlc291cmNlLW93bmVyLWNsaWVudCIsInN1YiI6IlBvcmt5UGlnIiwiYXV0aF90aW1lIjoxNTYwMzY3NDQzLCJpZHAiOiJsb2NhbCIsImNsaWVudF9uYW1lc3BhY2UiOiJEYWZmeSBEdWNrIiwicm9sZSI6WyJhZG1pbiIsImxpbWl0ZWQiXSwic2NvcGUiOlsid2l6YXJkIiwib2ZmbGluZV9hY2Nlc3MiXSwiYW1yIjpbImFyYml0cmFyeV9yZXNvdXJjZV9vd25lciJdfQ.V_YQY3w6PC-XPhKwGj5B12BR9IsDhIKT6mXY06_iymd_Wf1mrrFvXD7lsitVUosHwWQn7PfKIxX3-dGv0BJfjXDLbVSSiCUnRMI8_7Y4OaNqtAkCV_jD0ZlhrvVqXvpd-AOFjRldu67v8OT2wGjPPPlsUG5fM-exon0lqYSu4RoOLEvZmAKsW7erj09Nxoy8Kcyu7mib-GjE0Iq_amUdcm-vPmZC5TgEFd5itCoP4OLhXlNEKhHYWcWwLcLA0as-DeMPLY8axrdaifZDNed1hFO7Qy5mMR5qgIsQdM4vumHOmin9Z3QV9qa1YeS3Z_CDiDLBeovmVmjrHdbwHvw8lA' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Host: localhost:5001' \
  -H 'Postman-Token: 35d9b8fb-d42a-4619-b6c5-da1c4925a9c5,2f9c75c3-0d80-4532-8b54-80999609ccfb' \
  -H 'User-Agent: PostmanRuntime/7.13.0' \
  -H 'accept-encoding: gzip, deflate' \
  -H 'cache-control: no-cache'
```
## Response
``` 
[
    "Protected",
    "Data"
]
```



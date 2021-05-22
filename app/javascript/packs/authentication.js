import * as procoreIframeHelpers from '@procore/procore-iframe-helpers';

// Replace <YOUR_CLIENT_ID> with the Client ID found in the Procore Developer Portal.
const clientId = 'ad39a49ea2a27596f68fc1e3aa8365fdc183eed82942877ec623dbd1bfdcfc84';
const procoreHost = 'https://login-sandbox.procore.com/oauth/authorize';
const callbackUrl = 'http://localhost:3000/oauth_callback';

const login = () => {
  const iframeHelperContext = procoreIframeHelpers.initialize();
  const authUrl = `
    ${procoreHost}?client_id=${clientId}&response_type=code&redirect_uri=${callbackUrl}
  `;

  iframeHelperContext.authentication.authenticate({
    url: authUrl,
    onSuccess() {
      // This function fires when a message is received from the child window that
      // authentication was a success.
      window.location = '/';
    },
    onFailure(error) {
      // If the child authentication window exits without sending a success message,
      // this function will execute
      alert('authentication failed!');
    },
  });
};

document.addEventListener("DOMContentLoaded", function(event){
  document.getElementById('authentication-button').addEventListener('click', (event) => {
    login();
  });
});

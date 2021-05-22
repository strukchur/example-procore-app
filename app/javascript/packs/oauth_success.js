import * as procoreIframeHelpers from '@procore/procore-iframe-helpers';

document.addEventListener('DOMContentLoaded', () => {
  procoreIframeHelpers.initialize().authentication.notifySuccess({});
});

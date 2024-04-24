/* -*- Mode: IDL; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- */
/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * The origin of this IDL file is
 * https://w3c.github.io/webauthn/
 */

/***** Interfaces to Data *****/
[SecureContext, Exposed=Window]
interface PublicKeyCredential : Credential {
    [SameObject] readonly attribute ArrayBuffer              rawId;
    [SameObject] readonly attribute AuthenticatorResponse    response;
    readonly attribute DOMString?                            authenticatorAttachment;
    AuthenticationExtensionsClientOutputs getClientExtensionResults();
    static Promise<boolean> isConditionalMediationAvailable();
    PublicKeyCredentialJSON toJSON();
};

typedef DOMString Base64URLString;
// The structure of this object will be either
// RegistrationResponseJSON or AuthenticationResponseJSON
typedef object PublicKeyCredentialJSON;

dictionary RegistrationResponseJSON {
    required Base64URLString id;
    required Base64URLString rawId;
    required AuthenticatorAttestationResponseJSON response;
    DOMString authenticatorAttachment;
    required AuthenticationExtensionsClientOutputsJSON clientExtensionResults;
    required DOMString type;
};

dictionary AuthenticatorAttestationResponseJSON {
    required Base64URLString clientDataJSON;
    required Base64URLString authenticatorData;
    required sequence<DOMString> transports;
    // The publicKey field will be missing if pubKeyCredParams was used to
    // negotiate a public-key algorithm that the user agent doesn't
    // understand. (See section “Easily accessing credential data” for a
    // list of which algorithms user agents must support.) If using such an
    // algorithm then the public key must be parsed directly from
    // attestationObject or authenticatorData.
    Base64URLString publicKey;
    required long long publicKeyAlgorithm;
    // This value contains copies of some of the fields above. See
    // section “Easily accessing credential data”.
    required Base64URLString attestationObject;
};

dictionary AuthenticationResponseJSON {
    required Base64URLString id;
    required Base64URLString rawId;
    required AuthenticatorAssertionResponseJSON response;
    DOMString authenticatorAttachment;
    required AuthenticationExtensionsClientOutputsJSON clientExtensionResults;
    required DOMString type;
};

dictionary AuthenticatorAssertionResponseJSON {
    required Base64URLString clientDataJSON;
    required Base64URLString authenticatorData;
    required Base64URLString signature;
    Base64URLString userHandle;
};

dictionary AuthenticationExtensionsClientOutputsJSON {
};

partial dictionary CredentialCreationOptions {
    PublicKeyCredentialCreationOptions      publicKey;
};

partial dictionary CredentialRequestOptions {
    PublicKeyCredentialRequestOptions      publicKey;
};

partial interface PublicKeyCredential {
    static Promise<boolean> isUserVerifyingPlatformAuthenticatorAvailable();
};

partial interface PublicKeyCredential {
    static Promise<PublicKeyCredentialClientCapabilities> getClientCapabilities();
};

typedef record<DOMString, boolean> PublicKeyCredentialClientCapabilities;

partial interface PublicKeyCredential {
    static PublicKeyCredentialCreationOptions parseCreationOptionsFromJSON(PublicKeyCredentialCreationOptionsJSON options);
};

dictionary PublicKeyCredentialCreationOptionsJSON {
    required PublicKeyCredentialRpEntity                    rp;
    required PublicKeyCredentialUserEntityJSON              user;
    required Base64URLString                                challenge;
    required sequence<PublicKeyCredentialParameters>        pubKeyCredParams;
    unsigned long                                           timeout;
    sequence<PublicKeyCredentialDescriptorJSON>             excludeCredentials = [];
    AuthenticatorSelectionCriteria                          authenticatorSelection;
    sequence<DOMString>                                     hints = [];
    DOMString                                               attestation = "none";
    sequence<DOMString>                                     attestationFormats = [];
    AuthenticationExtensionsClientInputsJSON                extensions;
};

dictionary PublicKeyCredentialUserEntityJSON {
    required Base64URLString        id;
    required DOMString              name;
    required DOMString              displayName;
};

dictionary PublicKeyCredentialDescriptorJSON {
    required Base64URLString        id;
    required DOMString              type;
    sequence<DOMString>             transports;
};

dictionary AuthenticationExtensionsClientInputsJSON {
};

partial interface PublicKeyCredential {
    static PublicKeyCredentialRequestOptions parseRequestOptionsFromJSON(PublicKeyCredentialRequestOptionsJSON options);
};

dictionary PublicKeyCredentialRequestOptionsJSON {
    required Base64URLString                                challenge;
    unsigned long                                           timeout;
    DOMString                                               rpId;
    sequence<PublicKeyCredentialDescriptorJSON>             allowCredentials = [];
    DOMString                                               userVerification = "preferred";
    sequence<DOMString>                                     hints = [];
    AuthenticationExtensionsClientInputsJSON                extensions;
};

[SecureContext, Exposed=Window]
interface AuthenticatorResponse {
    [SameObject] readonly attribute ArrayBuffer      clientDataJSON;
};

[SecureContext, Exposed=Window]
interface AuthenticatorAttestationResponse : AuthenticatorResponse {
    [SameObject] readonly attribute ArrayBuffer      attestationObject;
    sequence<DOMString>                              getTransports();
    ArrayBuffer                                      getAuthenticatorData();
    ArrayBuffer?                                     getPublicKey();
    COSEAlgorithmIdentifier                          getPublicKeyAlgorithm();
};

[SecureContext, Exposed=Window]
interface AuthenticatorAssertionResponse : AuthenticatorResponse {
    [SameObject] readonly attribute ArrayBuffer      authenticatorData;
    [SameObject] readonly attribute ArrayBuffer      signature;
    [SameObject] readonly attribute ArrayBuffer?     userHandle;
};

dictionary PublicKeyCredentialParameters {
    required DOMString                    type;
    required COSEAlgorithmIdentifier      alg;
};

dictionary PublicKeyCredentialCreationOptions {
    required PublicKeyCredentialRpEntity         rp;
    required PublicKeyCredentialUserEntity       user;

    required BufferSource                             challenge;
    required sequence<PublicKeyCredentialParameters>  pubKeyCredParams;

    unsigned long                                timeout;
    sequence<PublicKeyCredentialDescriptor>      excludeCredentials = [];
    AuthenticatorSelectionCriteria               authenticatorSelection;
    sequence<DOMString>                          hints = [];
    DOMString                                    attestation = "none";
    sequence<DOMString>                          attestationFormats = [];
    AuthenticationExtensionsClientInputs         extensions;
};

dictionary PublicKeyCredentialEntity {
    required DOMString    name;
};

dictionary PublicKeyCredentialRpEntity : PublicKeyCredentialEntity {
    DOMString      id;
};

dictionary PublicKeyCredentialUserEntity : PublicKeyCredentialEntity {
    required BufferSource   id;
    required DOMString      displayName;
};

dictionary AuthenticatorSelectionCriteria {
    DOMString                    authenticatorAttachment;
    DOMString                    residentKey;
    boolean                      requireResidentKey = false;
    DOMString                    userVerification = "preferred";
};

enum AuthenticatorAttachment {
    "platform",
    "cross-platform"
};

enum ResidentKeyRequirement {
    "discouraged",
    "preferred",
    "required"
};

enum AttestationConveyancePreference {
    "none",
    "indirect",
    "direct",
    "enterprise"
};

dictionary PublicKeyCredentialRequestOptions {
    required BufferSource                challenge;
    unsigned long                        timeout;
    USVString                            rpId;
    sequence<PublicKeyCredentialDescriptor> allowCredentials = [];
    DOMString                            userVerification = "preferred";
    sequence<DOMString>                  hints = [];
    AuthenticationExtensionsClientInputs extensions;
};

dictionary AuthenticationExtensionsClientInputs {
};

dictionary AuthenticationExtensionsClientOutputs {
};

dictionary CollectedClientData {
    required DOMString           type;
    required DOMString           challenge;
    required DOMString           origin;
    DOMString                    topOrigin;
    boolean                      crossOrigin;
};

dictionary TokenBinding {
    required DOMString status;
    DOMString id;
};

enum TokenBindingStatus { "present", "supported" };

enum PublicKeyCredentialType {
    "public-key"
};

dictionary PublicKeyCredentialDescriptor {
    required DOMString                    type;
    required BufferSource                 id;
    sequence<DOMString>                   transports;
};

enum AuthenticatorTransport {
    "usb",
    "nfc",
    "ble",
    "smart-card",
    "hybrid",
    "internal"
};

typedef long COSEAlgorithmIdentifier;

enum UserVerificationRequirement {
    "required",
    "preferred",
    "discouraged"
};

enum ClientCapability {
    "conditionalCreate",
    "conditionalMediation",
    "hybridTransport",
    "passkeyPlatformAuthenticator",
    "userVerifyingPlatformAuthenticator",
};

enum PublicKeyCredentialHints {
    "security-key",
    "client-device",
    "hybrid",
};

partial dictionary AuthenticationExtensionsClientInputs {
  USVString appid;
};

partial dictionary AuthenticationExtensionsClientOutputs {
  boolean appid;
};

partial dictionary AuthenticationExtensionsClientInputs {
  USVString appidExclude;
};

partial dictionary AuthenticationExtensionsClientOutputs {
  boolean appidExclude;
};

partial dictionary AuthenticationExtensionsClientInputs {
    boolean credProps;
};

dictionary CredentialPropertiesOutput {
    boolean rk;
    USVString authenticatorDisplayName;
};

partial dictionary AuthenticationExtensionsClientOutputs {
    CredentialPropertiesOutput credProps;
};

dictionary AuthenticationExtensionsPRFValues {
    required BufferSource first;
    BufferSource second;
};

dictionary AuthenticationExtensionsPRFInputs {
    AuthenticationExtensionsPRFValues eval;
    record<USVString, AuthenticationExtensionsPRFValues> evalByCredential;
};

partial dictionary AuthenticationExtensionsClientInputs {
    AuthenticationExtensionsPRFInputs prf;
};

dictionary AuthenticationExtensionsPRFOutputs {
    boolean enabled;
    AuthenticationExtensionsPRFValues results;
};

partial dictionary AuthenticationExtensionsClientOutputs {
    AuthenticationExtensionsPRFOutputs prf;
};

partial dictionary AuthenticationExtensionsClientInputs {
    AuthenticationExtensionsLargeBlobInputs largeBlob;
};

enum LargeBlobSupport {
  "required",
  "preferred",
};

dictionary AuthenticationExtensionsLargeBlobInputs {
    DOMString support;
    boolean read;
    BufferSource write;
};

partial dictionary AuthenticationExtensionsClientOutputs {
    AuthenticationExtensionsLargeBlobOutputs largeBlob;
};

dictionary AuthenticationExtensionsLargeBlobOutputs {
    boolean supported;
    ArrayBuffer blob;
    boolean written;
};

partial dictionary AuthenticationExtensionsClientInputs {
  boolean uvm;
};

typedef sequence<unsigned long> UvmEntry;
typedef sequence<UvmEntry> UvmEntries;

partial dictionary AuthenticationExtensionsClientOutputs {
  UvmEntries uvm;
};

dictionary AuthenticationExtensionsSupplementalPubKeysInputs {
    required sequence<DOMString> scopes;
    DOMString attestation = "indirect";
    sequence<DOMString> attestationFormats = [];
};

partial dictionary AuthenticationExtensionsClientInputs {
    AuthenticationExtensionsSupplementalPubKeysInputs supplementalPubKeys;
};

dictionary AuthenticationExtensionsSupplementalPubKeysOutputs {
    required sequence<ArrayBuffer> signatures;
};

partial dictionary AuthenticationExtensionsClientOutputs {
    AuthenticationExtensionsSupplementalPubKeysOutputs supplementalPubKeys;
};

/*
// FIDO AppID Extension (appid)
// <https://w3c.github.io/webauthn/#sctn-appid-extension>
partial dictionary AuthenticationExtensionsClientInputs {
    USVString appid;
};

// FIDO AppID Extension (appid)
// <https://w3c.github.io/webauthn/#sctn-appid-extension>
partial dictionary AuthenticationExtensionsClientOutputs {
  boolean appid;
};
*/

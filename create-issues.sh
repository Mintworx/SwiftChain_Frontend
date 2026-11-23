#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
set -o pipefail

# Ensure the GitHub CLI is installed before running
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) could not be found. Please install it and run 'gh auth login' first."
    exit 1
fi

echo "🚀 Starting SwiftChain Issue Generation (120 Quality Fixes, Tests, & Enhancements)..."

# Function to generate the markdown and create the issue
create_issue() {
  local TITLE="$1"
  local DIR="$2"
  local GOAL="$3"
  local REQS="$4"
  local SCOPE="$5"
  local BRANCH="$6"
  local SPECIFIC_AC="$7"
  local COMMIT="$8"

  echo -e "\nCreating Issue: \"$TITLE\"..."

  cat <<EOF > temp_issue.md
Description
**johdanike** opened on Jun 25
Member
📁 Implementation Directory
\`$DIR\`

🎯 Goal
$GOAL

📋 Requirements
$REQS

🔧 Technical Scope
$SCOPE

🌿 Branch
\`git checkout -b $BRANCH\`

✅ Acceptance Criteria
$SPECIFIC_AC
- Strict Layered Architecture: Implement using the Component -> Hook -> Service pattern
- Data Source: Response data must be retrieved from the backend API. No Inline Mock Objects
- Screenshot of all implementations must be included in PR
- AI-generated PR submissions are strictly disallowed
- Closes #[issue_id] with a work summary included in the PR body
- Note a default in any of this will result to issue not being closed nor merged

📌 PR Requirements
- ⚠️ Assignment is required before starting — comment to request assignment
- PR must comply fully with CONTRIBUTING.md
- AI Agent submissions are DISALLOWED and will be closed without review
- Upload a screenshot showing all unit tests passing or API response
- PR description must include: Closes #[issue_id] and a brief summary of work done

💬 Example Commit
\`$COMMIT\`
EOF

  # Execute the GitHub CLI command
  gh issue create --title "$TITLE" --body-file temp_issue.md

  # Clean up the temp file
  rm -f temp_issue.md
}

# --- ISSUE DEFINITIONS (1 to 12: Core Escrow & Logistics) ---

create_issue \
  "Enhancement: Local Landmark Address Integration for Delivery Cards" \
  "components/deliveries/WorkflowCards.tsx" \
  "Enhance the Delivery Workflow Cards to display localized landmark references alongside standard street addresses." \
  "- Update the card layout to accommodate an optional 'Landmark' field.
- Highlight the landmark text visually (e.g., italics or a distinct badge) to aid drivers in complex street layouts.
- Ensure the layout remains responsive on mobile screens without text overflow." \
  "React, Tailwind CSS, Frontend UI" \
  "enhance/landmark-address-cards" \
  "- The Workflow Card must gracefully handle null landmark data without breaking layout." \
  "enhance(deliveries): integrate local landmark data into workflow cards"

create_issue \
  "Fix: Offline Mode Fallback Banner State Desync" \
  "components/shared/OfflineBanner.tsx" \
  "Resolve an issue where the Offline Mode Fallback Banner fails to disappear immediately upon network reconnection." \
  "- Debug the window 'online' event listener attached to the component.
- Ensure the state update triggering the banner's removal is not being blocked by React batching or stale closures.
- Implement a 2-second 'Back Online' success state before fully unmounting the banner." \
  "React Hooks (useEffect), Network APIs" \
  "fix/offline-banner-desync" \
  "- Disconnecting and reconnecting the internet must toggle the banner state within a 1-second margin." \
  "fix(ui): resolve offline fallback banner persistence issue"

create_issue \
  "Test: Wallet Disconnect & Session Cleanup Suite" \
  "__tests__/components/wallet/Disconnect.test.tsx" \
  "Implement comprehensive unit tests for the Wallet Disconnect & Session Cleanup flow to prevent regression." \
  "- Mock the Soroban/Stellar wallet provider context.
- Assert that clicking 'Disconnect' clears the local storage session keys.
- Assert that the user is correctly redirected to the onboarding or login screen post-disconnect." \
  "Jest, React Testing Library (RTL)" \
  "test/wallet-disconnect-cleanup" \
  "- Test suite must pass with 100% coverage for the session cleanup utility." \
  "test(wallet): implement unit tests for session cleanup and disconnect"

create_issue \
  "Enhancement: Offline-Ready QR Code Handoff Queuing" \
  "components/logistics/QrGenerator.tsx" \
  "Enhance the QR Code Handoff Generator to function seamlessly even when the driver enters a zero-connectivity zone." \
  "- Cache the required handoff payload in IndexedDB/localStorage before the driver reaches the destination.
- Generate the QR code purely from local state if the network request times out.
- Queue the successful scan confirmation to sync with the backend once connection is restored." \
  "React, IndexedDB/Service Workers, qrcode.react" \
  "enhance/offline-qr-handoff" \
  "- QR Code must render accurately by falling back to cached state when the browser is entirely offline." \
  "enhance(logistics): add offline caching to qr code handoff generator"

create_issue \
  "Enhancement: Localized Fiat-to-XLM Preview in Escrow Payment Lock" \
  "components/escrow/PaymentLock.tsx" \
  "Enhance the Escrow Payment Lock UI to display real-time NGN/USD conversions below the XLM total." \
  "- Fetch live or cached FX rates from the API service.
- Render the fiat equivalent dynamically as the user inputs the escrow amount.
- Add a tooltip explaining that smart contracts execute in XLM despite the fiat display." \
  "React, Currency Formatting, API Integration" \
  "enhance/fiat-xlm-escrow-preview" \
  "- Typing an amount in XLM must instantly reflect the equivalent NGN amount in a secondary text color." \
  "enhance(escrow): display localized fiat equivalent in payment lock ui"

create_issue \
  "Fix: Network Mismatch Detection Banner Re-render Loop" \
  "components/wallet/NetworkMismatch.tsx" \
  "Fix a performance bug where the Network Mismatch Banner enters an infinite re-render loop on certain wallet connections." \
  "- Audit the dependency array in the useEffect hook listening to the chain ID.
- Prevent state updates if the current chain ID strictly equals the target environment chain ID (Testnet/Mainnet).
- Profile the component to ensure rendering cycles sit at a baseline of 1 after network resolution." \
  "React Performance, React Profiler, Web3 Hooks" \
  "fix/network-mismatch-loop" \
  "- The React Profiler must show no unnecessary re-renders of the banner while the wallet is idle." \
  "fix(wallet): resolve infinite re-render loop in network mismatch banner"

create_issue \
  "Test: QR Code Scanner Permissions & Error Boundary" \
  "__tests__/components/logistics/QrScanner.test.tsx" \
  "Write rigorous interaction tests for the Driver QR Code Scanner, explicitly covering camera permission denials." \
  "- Mock the navigator.mediaDevices.getUserMedia API.
- Test the UI fallback state when the user denies camera permissions.
- Verify that a clear, instructional error message directs the driver to browser settings." \
  "Jest, React Testing Library (RTL)" \
  "test/qr-scanner-permissions" \
  "- The UI must render the 'Camera Permission Denied' fallback explicitly when the mock API rejects the promise." \
  "test(logistics): add error boundary tests for qr scanner camera permissions"

create_issue \
  "Fix: Statistics Section Skeleton Loader Cumulative Layout Shift" \
  "components/dashboard/Statistics.tsx" \
  "Resolve a severe Cumulative Layout Shift (CLS) issue caused by the Statistics Section skeleton loaders." \
  "- Set strict min-height and min-width CSS properties on the wrapper div.
- Ensure the skeleton loader blocks perfectly match the dimensions of the fully rendered data cards.
- Test across mobile, tablet, and desktop breakpoints to ensure dimensional parity." \
  "CSS/Tailwind, React Component Lifecycle, Web Vitals" \
  "fix/statistics-cls-loader" \
  "- Lighthouse score for CLS on the dashboard must register at 0.00 after the fix is applied." \
  "fix(dashboard): prevent layout shift by fixing statistics skeleton heights"

create_issue \
  "Enhancement: Driver Reputation Tokenized Score Integration" \
  "components/fleet/DriverReputation.tsx" \
  "Enhance the Driver Reputation & Rating UI to pull and display their on-chain tokenized reputation score." \
  "- Integrate a Web3 read call to the Soroban reputation contract.
- Create a specialized badge UI for 'Verified On-Chain Points' vs. 'Standard Platform Rating'.
- Add an informational modal explaining how completing escrows mints reputation tokens." \
  "React, Soroban RPC, Tailwind CSS" \
  "enhance/driver-reputation-tokens" \
  "- The UI must successfully render data fetched directly from the Stellar testnet/mainnet node." \
  "enhance(fleet): display on-chain tokenized score in driver reputation ui"

create_issue \
  "Fix: Insufficient Balance Warning UI Rendering Delay" \
  "components/wallet/BalanceWarning.tsx" \
  "Fix a race condition causing the Insufficient Balance Warning UI to flicker or delay upon modal load." \
  "- Optimize the balance fetching logic to run in parallel with the modal's animation sequence.
- Ensure the warning logic evaluates optimistic state before waiting for deep node confirmations.
- Prevent layout jumping by reserving space for the warning banner in the DOM." \
  "React Hooks, State Management, Asynchronous JavaScript" \
  "fix/balance-warning-delay" \
  "- The warning banner must be visible instantly upon modal render if the pre-fetched balance is too low." \
  "fix(wallet): optimize balance fetching to prevent warning ui delay"

create_issue \
  "Test: Escrow Release & Payout UI Multi-Signature Scenarios" \
  "__tests__/components/escrow/PayoutUI.test.tsx" \
  "Write automated tests verifying the Escrow Release UI correctly handles varied multi-signature states." \
  "- Mock a scenario where 1 of 2 required signatures is complete.
- Mock a scenario where the threshold is met and the 'Release Funds' button becomes active.
- Assert that clicking the disabled button prior to meeting the threshold throws no exceptions." \
  "Jest, React Testing Library (RTL)" \
  "test/escrow-payout-multisig" \
  "- The 'Release Funds' button must strictly possess the 'disabled' attribute if signatures < required threshold." \
  "test(escrow): implement multi-signature threshold tests for payout ui"

create_issue \
  "Enhancement: Multi-Lingual Support (Pidgin/Hausa/Yoruba/Igbo) for FAQ UI" \
  "components/support/HelpCenter.tsx" \
  "Enhance the FAQ & Help Center UI to support rapid toggling between standard English and localized Nigerian dialects." \
  "- Integrate an i18n library or simple Context provider for translation mappings.
- Implement a lightweight dropdown in the Help Center header for language selection.
- Extract all hardcoded string literals into a central JSON dictionary." \
  "React, i18next (or Context API), JSON Data Structuring" \
  "enhance/faq-multilingual" \
  "- Toggling the dropdown must instantly swap the FAQ question/answer text without requiring a page reload." \
  "enhance(support): integrate localization translations for faq help center"

# --- ISSUE DEFINITIONS (13 to 20: Performance, Data Virtualization, & Advanced Edge Cases) ---

create_issue \
  "Enhancement: Client-Side Image Compression for Delivery Proofs" \
  "components/logistics/ImageCapture.tsx" \
  "Reduce data payload sizes for drivers in low-bandwidth areas by compressing Delivery Proof images before upload." \
  "- Integrate a lightweight client-side compression library (e.g., browser-image-compression).
- Ensure images captured via the UI are resized and compressed to < 500KB while retaining readability.
- Show a visual 'Compressing...' state on the upload button." \
  "React, browser-image-compression, File APIs" \
  "enhance/image-capture-compression" \
  "- Uploaded files must be demonstrably smaller than the raw camera output while maintaining visual clarity." \
  "enhance(logistics): implement client-side compression for proof of delivery images"

create_issue \
  "Fix: Wallet Account Header Dropdown Z-Index Clipping" \
  "components/wallet/AccountHeader.tsx" \
  "Fix an overlapping bug where the Wallet Account Dropdown clips underneath sticky navigation bars or Mapbox canvases." \
  "- Inspect the stacking context of the header wrapper and the dropdown portal.
- Apply appropriate Tailwind z-index utility classes (e.g., z-50) to the dropdown menu.
- Ensure the fix doesn't cause the dropdown to overlap full-screen modals unexpectedly." \
  "CSS/Tailwind, UI/UX" \
  "fix/wallet-dropdown-zindex" \
  "- The dropdown menu must remain fully visible and on top of all underlying page content when clicked." \
  "fix(wallet): resolve z-index clipping for account header dropdown"

create_issue \
  "Enhancement: DOM Virtualization for Enterprise Fleet Table" \
  "components/fleet/EnterpriseDashboard.tsx" \
  "Improve rendering performance for enterprise managers tracking 1,000+ simultaneous deliveries by implementing table virtualization." \
  "- Replace standard map() rendering with a virtualization library like \`react-window\` or \`@tanstack/react-virtual\`.
- Ensure scrolling remains smooth (60fps) even when rendering thousands of rows.
- Maintain sticky table headers during vertical scrolling." \
  "React, react-window / tanstack-virtual, Performance Optimization" \
  "enhance/fleet-table-virtualization" \
  "- The browser DOM must only render the rows currently visible within the user's viewport." \
  "enhance(fleet): implement dom virtualization for massive fleet dashboard tables"

create_issue \
  "Fix: Blockchain Transaction Status Race Condition" \
  "components/wallet/TransactionTracker.tsx" \
  "Fix a race condition where the UI shows 'Pending' momentarily even after the backend/Soroban RPC already confirmed success." \
  "- Refactor the status polling logic to sync properly with the Web3 provider's receipt confirmation.
- Clear the polling interval strictly immediately upon receiving a terminal state (Success or Fail).
- Add a minor debounce to the 'Pending' UI state to prevent micro-flickers on fast network responses." \
  "React Hooks, Async JS, Soroban RPC" \
  "fix/transaction-status-race" \
  "- Transaction status must transition smoothly from Pending -> Success without flickering backward." \
  "fix(wallet): resolve polling race condition in blockchain transaction tracker"

create_issue \
  "Test: Global Command Palette Search Navigation (\`Cmd+K\`)" \
  "__tests__/components/shared/CommandPalette.test.tsx" \
  "Write automated interaction tests for the global Command Palette search functionality." \
  "- Mock the \`keydown\` event listener to trigger the palette using \`Cmd+K\` or \`Ctrl+K\`.
- Type a query into the search input and assert the list accurately filters matching delivery/escrow records.
- Assert that pressing \`Escape\` successfully unmounts the palette." \
  "Jest, React Testing Library (user-event)" \
  "test/command-palette-navigation" \
  "- The tests must successfully trigger the palette open state via keyboard events." \
  "test(shared): add interaction tests for global command palette"

create_issue \
  "Enhancement: OS-Aware Dark/Light Theme Persistence" \
  "components/shared/ThemeToggle.tsx" \
  "Enhance the Theme Toggle to respect the user's OS-level preferences and eliminate the Flash of Unstyled Content (FOUC)." \
  "- Check \`window.matchMedia('(prefers-color-scheme: dark)')\` on initial load.
- Ensure the user's manual override is saved to \`localStorage\` and prioritized over the OS preference.
- Inject a blocking script in the document \`<head>\` to apply the theme class before React hydrates to prevent FOUC." \
  "React, Tailwind Dark Mode, DOM Manipulation" \
  "enhance/theme-toggle-persistence" \
  "- Refreshing the page must load the saved theme instantly with absolutely zero flash of the opposite theme." \
  "enhance(shared): implement os-aware theme persistence and fix fouc"

create_issue \
  "Enhancement: Dynamic Breadcrumb Routing Mapping" \
  "components/shared/BreadcrumbNav.tsx" \
  "Enhance Breadcrumb Navigation to parse complex Web3/Logistics URLs into human-readable path names." \
  "- Hook into Next.js/React Router pathnames.
- Create a dictionary mapper (e.g., mapping \`/escrow/contract-id\` to \`Escrow > View Contract\`).
- Ensure the last item in the breadcrumb is highlighted as the active page and is not clickable." \
  "React Router / Next Navigation, UI Layout" \
  "enhance/dynamic-breadcrumbs" \
  "- Deep links must render clean, capitalized names instead of raw URL slugs or UUIDs." \
  "enhance(shared): map raw url slugs to human-readable breadcrumb labels"

create_issue \
  "Enhancement: Cross-Border Slippage Warning on Fiat-to-XLM Conversions" \
  "components/escrow/FiatXlmPreview.tsx" \
  "Add a highly visible slippage warning if the NGN/USD FX rate shifts drastically against XLM while the user is confirming a payment." \
  "- Define a slippage tolerance threshold (e.g., > 2% variance within 60 seconds).
- Display a warning icon and text alerting the user that the quoted fiat rate is highly volatile.
- Require an explicit checkbox acknowledgment if slippage exceeds 5%." \
  "React, Financial Logic, Error Handling UI" \
  "enhance/fiat-xlm-slippage" \
  "- The UI must block submission and require the checkbox if simulated slippage hits the 5% threshold." \
  "enhance(escrow): implement volatility slippage warnings for fiat to crypto previews"

# --- ISSUE DEFINITIONS (21 to 35: Bug Fixes) ---

create_issue \
  "Fix: React import at bottom of TxTracker.tsx" \
  "components/wallet/TxTracker.tsx" \
  "Move the \`import React from 'react'\` statement to the top of the file so it precedes all usage, satisfying ESLint import ordering and the rules-of-hooks plugin." \
  "- Cut the trailing \`import React from 'react'\` from line 175.
- Paste it at the top of the import block with other React imports.
- Confirm the file passes \`react-hooks/rules-of-hooks\` and import-order lint rules." \
  "React, ESLint, Import Ordering" \
  "fix/tx-tracker-react-import" \
  "- The \`import React from 'react'\` statement must appear at the top of the file before any usage of React." \
  "fix(wallet): move react import to top of tx tracker"

create_issue \
  "Fix: httpClient 401 hard-redirect breaks SPA UX" \
  "lib/httpClient.ts" \
  "Replace the unconditional \`window.location.assign('/login')\` on every 401 with a dispatchable auth event so API routes and SSR are not forced into a full-page redirect." \
  "- Remove the \`window.location.assign('/login')\` call from the response interceptor.
- Emit a custom auth event (or invoke a callback) that the auth layer can handle.
- Keep token removal but decouple navigation from the HTTP client." \
  "TypeScript, HTTP Interceptors, Auth" \
  "fix/http-client-401-redirect" \
  "- A 401 response must not force a full-page redirect; emit an auth event instead of calling window.location.assign." \
  "fix(core): stop hard-redirecting on 401 in http client"

create_issue \
  "Fix: useOffline back-online banner stale on rapid flapping" \
  "hooks/useOffline.tsx" \
  "Add a generation guard to the banner dismiss so rapid online/offline transitions cannot leave \`showBackOnline\` stuck visible after a stale verification resolves." \
  "- Track the current generation when scheduling the back-online timeout.
- Clear the dismiss timeout if a newer transition supersedes it before it fires.
- Ensure \`showBackOnline\` resets to false on the next offline event." \
  "React Hooks, Network APIs" \
  "fix/offline-banner-flapping" \
  "- Rapid offline/online transitions must not leave the back-online banner stuck visible." \
  "fix(core): guard offline banner on rapid network flapping"

create_issue \
  "Fix: NetworkMismatch infinite re-render loop" \
  "components/wallet/NetworkMismatch.tsx" \
  "Lock the chain-ID listening effect to the target network only, skipping state updates when the connected chain already matches Testnet/Mainnet." \
  "- Compare the connected chain ID against the target environment chain ID inside the effect.
- Return early (no setState) when chain IDs are equal.
- Profile with React Profiler to confirm baseline rendering cycles." \
  "React Performance, Web3 Hooks" \
  "fix/network-mismatch-loop" \
  "- The banner must not re-render while the wallet is idle on the correct network." \
  "fix(wallet): stop infinite re-render in network mismatch banner"

create_issue \
  "Fix: OfflineBanner desync on reconnect" \
  "components/ui/OfflineBanner.tsx" \
  "Synchronize banner removal with the \`useOffline\` generation counter so the banner disappears within 1 second of a confirmed reconnection." \
  "- Derive banner visibility from \`useOffline\`'s \`isOnline\` and generation.
- Force unmount within 1 second once reconnection is verified.
- Test offline → online transition timing." \
  "React Hooks, Network APIs" \
  "fix/offline-banner-desync" \
  "- Disconnecting and reconnecting the internet must toggle the banner state within a 1-second margin." \
  "fix(ui): resolve offline banner persistence on reconnect"

create_issue \
  "Fix: BalanceWarning flicker on modal load" \
  "components/wallet/BalanceWarning.tsx" \
  "Reserve DOM space for the warning banner and fetch balance in parallel with the modal animation so the warning appears instantly when the pre-fetched balance is too low." \
  "- Allocate a fixed-height container for the warning before the modal animates in.
- Kick off the balance fetch when the modal opens, not after animation completes.
- Evaluate optimistic balance state before awaiting deep node confirmation." \
  "React Hooks, State Management, Asynchronous JavaScript" \
  "fix/balance-warning-delay" \
  "- The warning banner must be visible instantly upon modal render if the pre-fetched balance is too low." \
  "fix(wallet): optimize balance fetching to prevent warning delay"

create_issue \
  "Fix: Statistics skeleton CLS" \
  "components/dashboard/Statistics.tsx" \
  "Set strict \`min-height\` and \`min-width\` CSS properties on the skeleton wrapper so skeleton blocks match the dimensions of fully rendered data cards across all breakpoints." \
  "- Apply fixed min-height/min-width to each skeleton card block.
- Verify dimensions match the loaded state at mobile, tablet, and desktop breakpoints.
- Run Lighthouse and confirm CLS is 0.00." \
  "CSS/Tailwind, Web Vitals" \
  "fix/statistics-cls-loader" \
  "- Lighthouse CLS on the dashboard must register at 0.00 after the fix." \
  "fix(dashboard): prevent layout shift in statistics skeleton"

create_issue \
  "Fix: TxTracker Pending→Success→Pending flicker" \
  "hooks/useTxTracker.ts" \
  "Debounce the terminal UI state and clear the polling interval immediately upon receiving Success or Failed so the status never flickers backward to Pending." \
  "- Add a small debounce before rendering a terminal state.
- Clear the polling interval synchronously when status becomes terminal.
- Ignore any late in-flight polling responses after terminal state is set." \
  "React Hooks, Async JS, Soroban RPC" \
  "fix/tx-tracker-flicker" \
  "- Transaction status must transition Pending -> Success without flickering backward to Pending." \
  "fix(wallet): debounce terminal state in tx tracker"

create_issue \
  "Fix: PaymentLock submits invalid on Enter key" \
  "components/escrow/PaymentLock.tsx" \
  "Guard \`handleSubmit\` with an early return when \`!isValidAmount\` so pressing Enter with an invalid XLM amount never invokes \`onLock\`." \
  "- Add \`if (!isValidAmount) return;\` as the first line of \`handleSubmit\`.
- Keep the existing input regex validation intact.
- Verify pressing Enter with empty or negative input does not call \`onLock\`." \
  "React, Form Validation" \
  "fix/payment-lock-invalid-submit" \
  "- Enter key must not call \`onLock\` when the XLM amount is invalid." \
  "fix(escrow): block payment lock submission on invalid amount"

create_issue \
  "Fix: QRScanner no permission-denied fallback" \
  "components/logistics/QrScanner.tsx" \
  "Render an explicit 'Camera Permission Denied' fallback UI when \`navigator.mediaDevices.getUserMedia\` rejects, with a link directing the driver to browser settings." \
  "- Mock-reject \`getUserMedia\` and capture the error branch.
- Render a fallback panel with a clear instructional message.
- Include a link/button that opens browser permission settings." \
  "React, MediaDevices API" \
  "fix/qr-scanner-permission-fallback" \
  "- The UI must render a 'Camera Permission Denied' fallback when \`getUserMedia\` rejects." \
  "fix(logistics): add camera permission denied fallback to qr scanner"

create_issue \
  "Fix: QrGenerator breaks offline" \
  "components/logistics/QrGenerator.tsx" \
  "Cache the handoff payload in IndexedDB before the driver reaches the destination, then render the QR purely from local state when the browser is offline." \
  "- Write the handoff payload to IndexedDB on generation.
- Detect offline state and read from cache instead of the network.
- Queue scan confirmation for backend sync when connectivity returns." \
  "React, IndexedDB, qrcode.react" \
  "fix/qr-generator-offline" \
  "- The QR Code must render from cached state when the browser is entirely offline." \
  "fix(logistics): add offline caching to qr generator"

create_issue \
  "Fix: DeliveryList crashes on null deliveries" \
  "components/DeliveryList.tsx" \
  "Add a null/undefined guard and an empty-state render before calling \`.map()\` on the deliveries list so the component never crashes on missing data." \
  "- Guard \`deliveries\` with a null check before mapping.
- Render an empty-state message when there are no deliveries.
- Preserve existing rendering when data is present." \
  "React, TypeScript" \
  "fix/delivery-list-null-crash" \
  "- The component must render an empty state instead of crashing when deliveries is null or undefined." \
  "fix(deliveries): guard against null deliveries in delivery list"

create_issue \
  "Fix: FiatXlmPreview hardcoded en-NG locale" \
  "components/escrow/FiatXlmPreview.tsx" \
  "Replace the hardcoded \`en-NG\` locale with the user's selected locale from \`LanguageContext\` so the fiat equivalent formats correctly for the active language." \
  "- Read the current locale from \`LanguageContext\`.
- Pass the locale to \`Intl.NumberFormat\` for fiat formatting.
- Fall back to \`en-US\` when no locale is set." \
  "React, i18n, Currency Formatting" \
  "fix/fiat-xlm-locale" \
  "- The fiat equivalent must format using the user's selected locale rather than hardcoded en-NG." \
  "fix(escrow): use user locale in fiat xlm preview"

create_issue \
  "Fix: AddressAutocomplete no debounce" \
  "components/logistics/AddressAutocomplete.tsx" \
  "Add a 300ms \`lodash.debounce\` (already a project dependency) around Places API calls so rapid typing does not fire a request on every keystroke." \
  "- Import \`debounce\` from \`lodash.debounce\`.
- Wrap the API call in a debounced function with 300ms wait.
- Cancel pending calls on component unmount." \
  "React, lodash.debounce" \
  "fix/address-autocomplete-debounce" \
  "- Rapid typing must result in a single API call after the 300ms debounce wait." \
  "fix(logistics): debounce address autocomplete api calls"

create_issue \
  "Fix: GlobalSearch Escape does not close" \
  "components/search/GlobalSearch.tsx" \
  "Add a \`keydown\` event listener for \`Escape\` that unmounts the Command Palette, matching the \`Cmd+K\`/\`Ctrl+K\` open behavior." \
  "- Attach a \`keydown\` listener on mount (cleanup on unmount).
- Detect \`Escape\` key and set the palette open state to false.
- Ensure focus returns to the triggering element when closing." \
  "React, Keyboard Events" \
  "fix/global-search-escape" \
  "- Pressing Escape must successfully unmount the command palette." \
  "fix(search): close global palette on escape key"

# --- ISSUE DEFINITIONS (36 to 50: Corrections / Code Quality) ---

create_issue \
  "Correction: TxTracker CONFIRMED spins Loader icon" \
  "components/wallet/TxTracker.tsx" \
  "Stop the Loader icon from spinning on \`CONFIRMED\` status; only \`PENDING\` should animate-spin the icon." \
  "- Change the animate-spin condition to apply only when status === 'PENDING'.
- Keep \`CONFIRMED\` showing a static CheckCircle icon.
- Verify CONFIRMED no longer displays a spinning loader." \
  "React, UI/UX" \
  "correct/tx-tracker-confirm-spin" \
  "- The Loader icon must not spin on CONFIRMED status; only PENDING should animate-spin." \
  "chore(ui): stop spinning loader on confirmed tx status"

create_issue \
  "Correction: httpClient sends Content-Type on GET" \
  "lib/httpClient.ts" \
  "Scope the \`Content-Type: application/json\` header to mutation methods (POST/PUT/PATCH/DELETE) only, omitting it from GET and HEAD requests." \
  "- Move the default header assignment inside a method check.
- Omit Content-Type for GET/HEAD requests.
- Keep it for all mutation methods." \
  "TypeScript, HTTP" \
  "correct/http-client-content-type" \
  "- GET and HEAD requests must not include a Content-Type header." \
  "chore(core): scope content-type header to mutations"

create_issue \
  "Correction: Unify auth token key across httpClient and authStore" \
  "lib/httpClient.ts, store/authStore.ts" \
  "Define a shared \`TOKEN_KEY\` constant and use it in both \`lib/httpClient.ts\` (\`localStorage.getItem('authToken')\`) and \`store/authStore.ts\` so the key is consistent." \
  "- Create \`lib/auth-token.ts\` exporting \`TOKEN_KEY = 'authToken'\`.
- Import and use \`TOKEN_KEY\` in httpClient and authStore.
- Remove all hardcoded 'authToken' string literals." \
  "TypeScript, Auth" \
  "correct/auth-token-key-unify" \
  "- The authToken key must be consistent between the http client and the auth store." \
  "chore(core): unify auth token storage key"

create_issue \
  "Correction: Escalate no-console to error in CI" \
  "eslint.config.mjs, package.json" \
  "Change the \`no-console\` rule from \`warn\` to \`error\` and add \`--max-warnings 0\` to the lint script so console statements fail the CI lint build." \
  "- Set \`'no-console': 'error'\` in eslint.config.mjs.
- Update \`pnpm run lint\` to \`eslint . --max-warnings 0\`.
- Verify CI lint fails on any console statement." \
  "ESLint, CI" \
  "correct/eslint-no-console-error" \
  "- Console statements must fail the lint build in CI (max-warnings 0)." \
  "chore(ci): escalate no-console lint rule to error"

create_issue \
  "Correction: Add aria-label to icon-only buttons" \
  "components/shared/ThemeToggle.tsx, components/ui/OfflineBanner.tsx" \
  "Add accessible names (\`aria-label\` or \`aria-labelledby\`) to every icon-only button so screen readers can announce their purpose." \
  "- Audit ThemeToggle and OfflineBanner for icon-only buttons.
- Add \`aria-label\` describing each button's action.
- Test with a screen reader or axe-core." \
  "Accessibility, ARIA" \
  "correct/icon-button-aria" \
  "- Every icon-only button must have an aria-label or aria-labelledby." \
  "chore(a11y): add accessible names to icon buttons"

create_issue \
  "Correction: Theme FOUC on hydration" \
  "hooks/useTheme.ts, app/layout.tsx" \
  "Inject a blocking \`<script>\` in \`document.head\` that applies the theme class before React hydrates, eliminating the flash of the opposite theme on page refresh." \
  "- Add a blocking script tag in \`app/layout.tsx\` head.
- The script reads \`localStorage\`/\`matchMedia\` and sets \`document.documentElement.className\`.
- \`useTheme.ts\` must respect the pre-applied class on hydration." \
  "React, Tailwind Dark Mode" \
  "correct/theme-fouc" \
  "- Page refresh must load the saved theme with zero flash of the opposite theme." \
  "chore(ui): prevent theme flash of unstyled content"

create_issue \
  "Correction: Type API responses in transaction formatters" \
  "lib/transactionFormatters.ts" \
  "Add Zod schemas validating wire-format transaction and escrow responses so formatter inputs are typed rather than \`any\`." \
  "- Define Zod schemas for transaction history and escrow status wire shapes.
- Validate API responses at the service boundary before formatting.
- Replace \`any\` parameters with inferred Zod types." \
  "TypeScript, Zod" \
  "correct/transaction-formatter-types" \
  "- Formatter inputs must be validated against Zod schemas, not typed as any." \
  "chore(types): add zod schemas for api transaction responses"

create_issue \
  "Correction: Make EscrowDetails.status required" \
  "types/escrow.ts" \
  "Change \`status?:\` to \`status:\` in \`EscrowDetails\` and add an \`Unknown\` fallback render in all consuming components so undefined status never breaks the UI.
- Make \`status\` a required field on \`EscrowDetails\`.
- Add \`Unknown\` to the \`EscrowStatus\` union if missing.
- Add \`?? 'Unknown'\` fallback in \`formatEscrowStatus\` and style lookups." \
  "TypeScript" \
  "correct/escrow-status-required" \
  "- EscrowDetails.status must be required with an Unknown fallback render." \
  "chore(types): make escrow details status required"

create_issue \
  "Correction: Reset wallet balance on disconnect" \
  "hooks/useWalletBalance.ts, hooks/useAuth.ts" \
  "Clear the wallet balance state in the auth disconnect handler so a disconnected session never displays a stale balance." \
  "- Wire \`useAuth\`'s disconnect handler to reset balance in \`useWalletBalance\`.
- Set balance to \`null\`/zero on disconnect.
- Verify balance reappears only after reconnect and refetch." \
  "React Hooks, Auth" \
  "correct/wallet-balance-reset" \
  "- Wallet balance must reset to null/zero on disconnect." \
  "fix(wallet): clear balance state on disconnect"

create_issue \
  "Correction: DisputeForm empty evidence validation" \
  "components/escrow/DisputeForm.tsx" \
  "Add client-side required-file validation so the form rejects submission when zero evidence files are attached." \
  "- Track attached evidence files in form state.
- Block submit when the evidence list is empty.
- Show an inline validation error above the submit button." \
  "React, Form Validation" \
  "correct/dispute-form-evidence" \
  "- The form must reject submission when no evidence files are attached." \
  "fix(escrow): require evidence files in dispute form"

create_issue \
  "Correction: MultiSigApprovals aria-disabled" \
  "components/wallet/MultiSigApprovals.tsx" \
  "Add \`aria-disabled=\"true\"\` to the disabled approval button and a live region announcing the current signature threshold status." \
  "- Set \`aria-disabled\` based on whether the threshold is met.
- Add an \`aria-live=\"polite\"\` region for threshold updates.
- Verify screen readers announce 'disabled, X of Y signatures required'." \
  "Accessibility, ARIA" \
  "correct/multisig-aria-disabled" \
  "- Below threshold, the approval button must announce aria-disabled and threshold status." \
  "chore(a11y): add aria-disabled to multisig approvals"

create_issue \
  "Correction: CurrencySelector driven by API" \
  "components/layout/CurrencySelector.tsx" \
  "Fetch fiat currency options from \`currencyRateService\` instead of hardcoding NGN/USD so the selector reflects backend-supported currencies." \
  "- Call \`currencyRateService\` to list supported fiat currencies.
- Populate the selector dropdown from the API response.
- Show a loading state while fetching currency options." \
  "React, API Integration" \
  "correct/currency-selector-api" \
  "- Currency options must come from the backend rate service, not hardcoded values." \
  "fix(layout): load currency options from api"

create_issue \
  "Correction: Tree-shake date-fns imports" \
  "package.json, multiple hooks/components" \
  "Replace root \`date-fns\` imports with subpath imports (e.g., \`date-fns/locale\`) so unused locales are tree-shaken and the bundle shrinks." \
  "- Audit all \`import ... from 'date-fns'\` statements.
- Switch locale imports to \`date-fns/locale/<locale>\`.
- Confirm bundle size decreases in the build output." \
  "JavaScript, Bundling" \
  "correct/date-fns-tree-shake" \
  "- date-fns locales must be imported via subpaths to reduce bundle size." \
  "chore(perf): tree-shake date-fns locale imports"

create_issue \
  "Correction: Import prismjs CSS in ContractMockup" \
  "components/product/ContractMockup.tsx" \
  "Import \`prismjs/themes/prism.css\` so code blocks render with syntax highlighting styles instead of unstyled plain text." \
  - Add \`import 'prismjs/themes/prism.css';\` to ContractMockup.tsx.
- Verify code blocks display with colors and token styling.
- Confirm no CSS conflicts with Tailwind." \
  "CSS, prismjs" \
  "correct/contract-mockup-prism-css" \
  "- Code blocks must render with prismjs syntax highlighting styles." \
  "chore(ui): import prismjs css in contract mockup"

create_issue \
  "Correction: Align tsconfig.jest.json with tsconfig.json" \
  "tsconfig.jest.json, tsconfig.json" \
  "Synchronize \`include\`/\`exclude\` between \`tsconfig.jest.json\` and \`tsconfig.json\` so tests are type-checked consistently under \`ts-jest\`." \
  "- Mirror the \`include\` globs from tsconfig.json into tsconfig.jest.json.
- Mirror the \`exclude\` globs (tests, .next, node_modules).
- Run \`tsc --noEmit -p tsconfig.jest.json\` to verify." \
  "TypeScript, Jest" \
  "correct/tsconfig-jest-sync" \
  "- Jest type-check config must match the main tsconfig exclusions." \
  "chore(types): sync jest tsconfig with main tsconfig"

# --- ISSUE DEFINITIONS (51 to 70: Upgrades / Dependency Modernization) ---

create_issue \
  "Upgrade: Next.js 16.1.6 → latest 16.x" \
  "package.json" \
  "Upgrade \`next\` to the latest 16.x patch/minor to pick up App Router improvements and bug fixes." \
  "- Bump \`next\` to latest 16.x in package.json.
- Run \`pnpm install\` and \`pnpm run build\`.
- Fix any deprecation warnings introduced by the upgrade." \
  "Next.js, Framework" \
  "upgrade/next-js-latest" \
  "- The application must build and run on the latest Next.js 16.x release." \
  "chore(deps): upgrade next to latest 16.x"

create_issue \
  "Upgrade: React 19.2.3 → latest 19.x" \
  "package.json" \
  "Upgrade \`react\` and \`react-dom\` to the latest 19.x for React Compiler compatibility and performance improvements." \
  "- Bump react/react-dom to latest 19.x.
- Run \`pnpm install\`, \`pnpm run build\`, and \`pnpm run type-check\`.
- Verify React Compiler optimizations apply where annotated." \
  "React, Framework" \
  "upgrade/react-latest" \
  "- The app must compile with the latest React 19.x and React Compiler." \
  "chore(deps): upgrade react to latest 19.x"

create_issue \
  "Upgrade: Tailwind CSS v4 → latest" \
  "package.json, tailwind.config.ts, postcss.config.mjs" \
  "Upgrade \`tailwindcss\`, \`@tailwindcss/vite\`, and \`postcss\` to the latest v4 and adopt the new \`@tailwindcss/postcss\` config where applicable." \
  "- Bump Tailwind packages to latest v4.
- Update tailwind.config.ts and postcss.config.mjs to new v4 format.
- Run \`pnpm run build\` and verify styles compile." \
  "CSS, Tailwind" \
  "upgrade/tailwind-v4-latest" \
  "- The build must succeed with latest Tailwind CSS v4 and the new postcss config." \
  "chore(deps): upgrade tailwind css to latest v4"

create_issue \
  "Upgrade: TanStack Query v5 → latest" \
  "package.json" \
  "Upgrade \`@tanstack/react-query\` to the latest v5 for \`useSuspenseQuery\` and improved React 19 support." \
  "- Bump \`@tanstack/react-query\` to latest v5.
- Review migration notes for breaking changes.
- Run the full test suite to confirm query behavior." \
  "React, Data Fetching" \
  "upgrade/tanstack-query-latest" \
  "- The app must use latest TanStack Query v5 with React 19 support." \
  "chore(deps): upgrade tanstack query to latest"

create_issue \
  "Upgrade: zod v3 → v4" \
  "package.json, hooks, forms" \
  "Plan and execute migration of form validation schemas from zod v3 to zod v4." \
  "- Bump \`zod\` to v4 in package.json.
- Update all \`z.object\`, \`z.string\`, etc. calls to v4 API.
- Run tests to confirm schemas still validate correctly." \
  "TypeScript, Zod" \
  "upgrade/zod-v4" \
  "- All form schemas must migrate from zod v3 to the v4 API." \
  "chore(deps): upgrade zod to v4"

create_issue \
  "Upgrade: ESLint v9 flat config → latest" \
  "package.json, eslint.config.mjs" \
  "Upgrade ESLint to the latest v9, keep the flat config, and remove any deprecated rules flagged by the new release." \
  "- Bump \`eslint\` to latest v9.
- Review \`eslint.config.mjs\` for deprecated rules.
- Run \`pnpm run lint\` and fix new errors." \
  "ESLint, Linting" \
  "upgrade/eslint-latest" \
  "- Lint must pass with latest ESLint v9 flat config." \
  "chore(deps): upgrade eslint to latest v9"

create_issue \
  "Upgrade: @tanstack/react-table v8 → latest" \
  "package.json" \
  "Upgrade \`@tanstack/react-table\` from \`^8.0.0\` to the latest v8 for virtualized-row fixes and performance improvements." \
  "- Bump \`@tanstack/react-table\` to latest v8.
- Review v8 migration guide for API changes.
- Verify fleet tables still render and virtualize correctly." \
  "React, Tables" \
  "upgrade/tanstack-table-latest" \
  "- Fleet tables must use latest react-table with virtualization fixes." \
  "chore(deps): upgrade tanstack table to latest v8"

create_issue \
  "Upgrade: @tanstack/react-virtual v3 → latest" \
  "package.json" \
  "Upgrade \`@tanstack/react-virtual\` to the latest v3 for smoother 60fps rendering in large fleet tables." \
  "- Bump \`@tanstack/react-virtual\` to latest.
- Confirm virtualizer options remain compatible.
- Measure scroll performance with 1000+ rows." \
  "React, Performance" \
  "upgrade/tanstack-virtual-latest" \
  "- Virtualized tables must render at 60fps with latest react-virtual." \
  "chore(deps): upgrade tanstack virtual to latest"

create_issue \
  "Upgrade: socket.io-client v4 → v5" \
  "package.json" \
  "Upgrade \`socket.io-client\` from \`^4.8.4\` to v5 and test WebSocket reconnect behavior under flaky network conditions." \
  "- Bump \`socket.io-client\` to v5.
- Align server-side socket.io version if co-located.
- Test reconnect after network drop and server restart." \
  "Networking, WebSockets" \
  "upgrade/socket-io-v5" \
  "- Real-time updates must reconnect reliably on socket.io v5." \
  "chore(deps): upgrade socket.io client to v5"

create_issue \
  "Upgrade: lucide-react → latest" \
  "package.json" \
  "Upgrade \`lucide-react\` to the latest for new icons and consistency across the UI." \
  "- Bump \`lucide-react\` to latest.
- Audit icon usages for renamed or removed icons.
- Run \`pnpm run lint\` and \`pnpm run build\`." \
  "UI, Icons" \
  "upgrade/lucide-react-latest" \
  "- The UI must use the latest lucide-react icon set." \
  "chore(deps): upgrade lucide-react to latest"

create_issue \
  "Upgrade: framer-motion v12 → latest" \
  "package.json" \
  "Upgrade \`framer-motion\` to the latest for shared-layout animations and improved React 19 support." \
  "- Bump \`framer-motion\` to latest.
- Review breaking changes in the changelog.
- Verify page transitions and exit animations still work." \
  "React, Animation" \
  "upgrade/framer-motion-latest" \
  "- Page transitions must use latest framer-motion shared-layout APIs." \
  "chore(deps): upgrade framer-motion to latest"

create_issue \
  "Upgrade: next-themes → latest" \
  "package.json" \
  "Upgrade \`next-themes\` to the latest for \`forcedTheme\` and \`attribute\` options." \
  "- Bump \`next-themes\` to latest.
- Configure \`forcedTheme\` and \`attribute\` in ThemeProvider.
- Verify theme persistence across SSR and client." \
  "React, Theming" \
  "upgrade/next-themes-latest" \
  "- The theme toggle must support forcedTheme and attribute options." \
  "chore(deps): upgrade next-themes to latest"

create_issue \
  "Upgrade: zustand v4 → latest" \
  "package.json" \
  "Upgrade \`zustand\` to the latest v4 for selector performance improvements and devtools enhancements." \
  "- Bump \`zustand\` to latest v4.
- Review selector memoization changes.
- Verify stores still update components correctly." \
  "State Management" \
  "upgrade/zustand-latest" \
  "- Store selectors must use latest zustand performance improvements." \
  "chore(deps): upgrade zustand to latest"

create_issue \
  "Upgrade: axios v1.6 → latest v1.x" \
  "package.json" \
  "Upgrade \`axios\` from \`^1.6.0\` to the latest v1.x for security patches and interceptor fixes." \
  "- Bump \`axios\` to latest v1.x.
- Review interceptors in \`lib/httpClient.ts\` for compatibility.
- Run tests to confirm HTTP behavior unchanged." \
  "HTTP, Networking" \
  "upgrade/axios-latest" \
  "- The HTTP client must use latest axios v1.x with security patches." \
  "chore(deps): upgrade axios to latest v1.x"

create_issue \
  "Upgrade: react-hook-form v7 → latest" \
  "package.json" \
  "Upgrade \`react-hook-form\` to the latest v7 for resolver changes and performance improvements." \
  "- Bump \`react-hook-form\` to latest.
- Update resolver usages if the API changed.
- Run form tests to confirm validation still works." \
  "React, Forms" \
  "upgrade/react-hook-form-latest" \
  "- Forms must use latest react-hook-form resolver APIs." \
  "chore(deps): upgrade react-hook-form to latest"

create_issue \
  "Upgrade: recharts v3 → latest" \
  "package.json" \
  "Upgrade \`recharts\` to the latest for charting improvements and responsiveness fixes." \
  "- Bump \`recharts\` to latest.
- Check for breaking chart component API changes.
- Verify dashboard charts render correctly." \
  "React, Charts" \
  "upgrade/recharts-latest" \
  "- Dashboards must render charts with latest recharts responsiveness." \
  "chore(deps): upgrade recharts to latest"

create_issue \
  "Upgrade: leaflet / react-leaflet → latest" \
  "package.json" \
  "Upgrade \`leaflet\` and \`react-leaflet\` to the latest for map tile attribution and mobile touch fixes." \
  "- Bump \`leaflet\` and \`react-leaflet\` to latest.
- Verify map initialization and tile layers still work.
- Test touch interactions on mobile breakpoints." \
  "Maps, Leaflet" \
  "upgrade/leaflet-latest" \
  "- Maps must use latest leaflet with mobile touch fixes." \
  "chore(deps): upgrade leaflet and react-leaflet"

create_issue \
  "Upgrade: Cypress E2E → latest" \
  "cypress/, package.json" \
  "Upgrade Cypress to the latest and align it with the component testing runner." \
  "- Bump \`cypress\` to latest.
- Update \`cypress.config.ts\` if required by the new version.
- Run the E2E suite to confirm green tests." \
  "Testing, E2E" \
  "upgrade/cypress-latest" \
  "- E2E tests must run on the latest Cypress version." \
  "chore(deps): upgrade cypress to latest"

create_issue \
  "Upgrade: Jest v30 + ts-jest → latest" \
  "package.json, tsconfig.jest.json" \
  "Upgrade \`jest\` and \`ts-jest\` to the latest, verifying \`tsconfig.jest.json\` compatibility." \
  "- Bump \`jest\` and \`ts-jest\` to latest.
- Update \`tsconfig.jest.json\` if required.
- Run \`pnpm test\` and confirm all suites pass." \
  "Testing, Jest" \
  "upgrade/jest-latest" \
  "- Unit tests must run on latest Jest and ts-jest." \
  "chore(deps): upgrade jest and ts-jest"

create_issue \
  "Upgrade: TypeScript 5.0.0 → latest 5.x" \
  "package.json, tsconfig.json" \
  "Upgrade \`typescript\` from \`^5.0.0\` to the latest 5.x for \`infer\`/\`satisfies\` improvements and stricter checking." \
  "- Bump \`typescript\` to latest 5.x.
- Run \`pnpm run type-check\` and fix new type errors.
- Verify \`tsconfig.json\` remains valid." \
  "TypeScript" \
  "upgrade/typescript-latest" \
  "- The project must compile with the latest TypeScript 5.x." \
  "chore(deps): upgrade typescript to latest 5.x"

# --- ISSUE DEFINITIONS (71 to 90: New Feature Implementations) ---

create_issue \
  "Implement: useOptimisticEscrow hook" \
  "hooks/useOptimisticEscrow.ts" \
  "Add a hook that optimistically updates escrow lock/release state in the UI and rolls back if the backend rejects the transaction." \
  "- Implement optimistic update for escrow lock and release.
- Roll back UI state on backend error.
- Expose \`isOptimistic\` and \`rollback\` to consumers." \
  "React Hooks, Escrow" \
  "implement/use-optimistic-escrow" \
  "- The UI must update optimistically and roll back on backend error." \
  "feat(hooks): add optimistic escrow lock release hook"

create_issue \
  "Implement: DeliveryProofGallery component" \
  "components/logistics/DeliveryProofGallery.tsx" \
  "Build a gallery component to view multiple delivery proof images with zoom capability." \
  "- Render a grid of proof image thumbnails.
- Open a zoomable modal on image click.
- Support keyboard navigation and close on Escape." \
  "React, Image View" \
  "implement/delivery-proof-gallery" \
  "- Users must view multiple delivery proof images with zoom." \
  "feat(logistics): add delivery proof image gallery"

create_issue \
  "Implement: PayoutSchedule calendar" \
  "components/escrow/PayoutSchedule.tsx" \
  "Create a calendar UI for scheduling future escrow payout dates." \
  "- Render a monthly calendar view.
- Allow selecting a future payout date.
- Persist the selected date via the payout service." \
  "React, Date Picker" \
  "implement/payout-schedule" \
  "- Users must select and schedule future payout dates." \
  "feat(escrow): add payout schedule calendar"

create_issue \
  "Implement: RouteOptimizer waypoints DnD" \
  "components/shipments/RouteOptimizer.tsx" \
  "Add drag-and-drop reordering of route waypoints using \`@dnd-kit\` (already a dependency)." \
  "- Wrap waypoints in \`@dnd-kit\` draggable elements.
- Reorder the waypoint list on drop.
- Persist the new order to the route optimization service." \
  "React, @dnd-kit" \
  "implement/route-optimizer-dnd" \
  "- Waypoints must be reorderable via drag and drop." \
  "feat(shipments): add drag-and-drop waypoint reorder"

create_issue \
  "Implement: DriverEarningsExportCSV" \
  "components/wallet/DriverEarningsDashboard.tsx" \
  "Add a CSV export button to the driver earnings dashboard using the existing \`lib/csvExport.ts\` utility." \
  "- Add an 'Export CSV' button to the dashboard.
- Map earnings data to CSV rows via \`csvExport\`.
- Trigger a browser download of the generated CSV." \
  "React, CSV Export" \
  "implement/driver-earnings-csv" \
  "- Drivers must download their earnings as a CSV file." \
  "feat(wallet): add csv export for driver earnings"

create_issue \
  "Implement: AuditTrailFilter date-range" \
  "components/dashboard/AuditTrailList.tsx" \
  "Add a date-range filter to the audit trail list using \`date-fns\`." \
  "- Add start/end date pickers above the audit list.
- Filter audit entries by date range client-side.
- Clear the filter with a reset button." \
  "React, date-fns" \
  "implement/audit-trail-filter" \
  "- Admins must filter audit trails by a custom date range." \
  "feat(dashboard): add date-range filter to audit trail"

create_issue \
  "Implement: WebSocketReconnectToast" \
  "lib/WebSocketProvider.tsx" \
  "Display a sonner toast notification when the WebSocket attempts to reconnect after a drop." \
  "- Hook into WebSocket \`reconnecting\` and \`reconnected\` events.
- Show an info toast on reconnect attempt.
- Show a success toast once reconnected." \
  "React, WebSockets" \
  "implement/ws-reconnect-toast" \
  "- Users must see a toast when the WebSocket reconnects after a drop." \
  "feat(core): add websocket reconnect toast"

create_issue \
  "Implement: EscrowDisputeEvidenceTimeline" \
  "components/escrow/DisputeCasePortal.tsx" \
  "Add a chronological timeline to the dispute portal showing evidence uploads and verdict events." \
  "- Fetch evidence and verdict events from the dispute service.
- Render them sorted by timestamp in a vertical timeline.
- Highlight the current verdict state." \
  "React, Escrow" \
  "implement/dispute-evidence-timeline" \
  "- The dispute portal must show a chronological evidence timeline." \
  "feat(escrow): add evidence timeline to dispute portal"

create_issue \
  "Implement: LoadMatchingBoard auto-refresh" \
  "components/driver/LoadMatchingBoard.tsx" \
  "Add an auto-refresh toggle that polls for new loads every 30 seconds." \
  "- Add a toggle switch to enable/disable auto-refresh.
- Poll \`loadMatchingService\` every 30s when enabled.
- Stop polling when the component unmounts or toggle is off." \
  "React, Polling" \
  "implement/load-board-auto-refresh" \
  "- Drivers must be able to toggle auto-refresh for new loads every 30s." \
  "feat(driver): add auto-refresh to load matching board"

create_issue \
  "Implement: KycDocumentScanner validation" \
  "components/onboarding/KycOnboardingFlow.tsx" \
  "Validate KYC document file type and size client-side before allowing upload." \
  "- Check file extension/MIME type against allowed list.
- Enforce a maximum file size.
- Show an inline error if validation fails before upload." \
  "React, File Validation" \
  "implement/kyc-document-validation" \
  "- KYC uploads must validate file type and size client-side before upload." \
  "feat(onboarding): add client-side kyc document validation"

create_issue \
  "Implement: FleetMapCluster marker clustering" \
  "components/fleet/FleetMapClient.tsx" \
  "Cluster driver markers on the fleet map when 1,000+ drivers are visible." \
  "- Integrate a Leaflet marker clustering plugin.
- Cluster nearby driver markers at low zoom levels.
- Expand clusters on click to show individual drivers." \
  "React, Leaflet" \
  "implement/fleet-map-clustering" \
  "- The map must cluster driver markers when density is high." \
  "feat(fleet): add marker clustering to fleet map"

create_issue \
  "Implement: IoTDeviceStatusWidget" \
  "components/product/IoTDashboard.tsx" \
  "Show real-time IoT device health status via WebSocket updates." \
  "- Connect to the IoT WebSocket channel.
- Render device health badges (online/offline/degraded).
- Update badges in real time as messages arrive." \
  "React, IoT" \
  "implement/iot-device-widget" \
  "- The dashboard must show real-time IoT device health status." \
  "feat(product): add iot device status widget"

create_issue \
  "Implement: ReferralCodeInput on register" \
  "components/forms/RegisterForm.tsx" \
  "Add an optional referral code input field to the registration form with backend validation." \
  - Add a referral code text input to RegisterForm.
- Send the code to the registration service on submit.
- Show an error if the referral code is invalid." \
  "React, Forms" \
  "implement/referral-code-input" \
  "- Registration must accept an optional referral code and validate it with the backend." \
  "feat(auth): add referral code field to registration"

create_issue \
  "Implement: ShipmentCustomsAutoFill" \
  "components/shipments/CustomsDocumentationManager.tsx" \
  "Auto-fill HS codes and customs fields based on the shipment origin and destination." \
  "- Call the customs service with origin/destination to fetch HS codes.
- Pre-fill the customs form fields with the response.
- Allow the user to override auto-filled values." \
  "React, API" \
  "implement/customs-autofill" \
  "- Customs forms must auto-fill HS codes from the route." \
  "feat(shipments): auto-fill customs hs codes"

create_issue \
  "Implement: PushNotificationPermissionPrompt" \
  "components/layout/PushNotificationButton.tsx" \
  "Show a one-time push notification permission prompt on a user's first visit." \
  - Detect if push permission has not yet been requested.
- Show a one-time prompt to enable notifications.
- Remember the user's choice in localStorage so it doesn't reappear." \
  "React, Push API" \
  "implement/push-permission-prompt" \
  "- Users must receive a one-time push notification permission prompt." \
  "feat(layout): add push notification permission prompt"

create_issue \
  "Implement: ReceiptVerificationOCRPreview" \
  "components/shipments/ReceiptVerification.tsx" \
  "Preview OCR-extracted receipt fields before the user confirms receipt." \
  "- Run OCR on the uploaded receipt image.
- Display extracted fields (amount, date, merchant) for review.
- Let the user edit or confirm before submitting." \
  "React, OCR" \
  "implement/receipt-ocr-preview" \
  "- Users must preview OCR-extracted fields before confirming receipt." \
  "feat(shipments): add ocr preview for receipt verification"

create_issue \
  "Implement: DriverReviewRatingChart" \
  "components/fleet/DriverReputation.tsx" \
  "Add a rating distribution chart to the driver reputation UI using \`recharts\`." \
  - Fetch rating counts per star value from the reputation service.
- Render a bar chart of the rating distribution.
- Show the average score alongside the chart." \
  "React, recharts" \
  "implement/driver-rating-chart" \
  "- Driver reputation must show a rating distribution chart." \
  "feat(fleet): add driver rating distribution chart"

create_issue \
  "Implement: AdminRefundBulkAction" \
  "components/admin/refunds/RefundListView.tsx" \
  "Allow admins to select multiple refunds and approve or reject them in bulk." \
  - Add checkboxes to each refund row.
- Add bulk 'Approve' and 'Reject' action buttons.
- Send bulk action to the admin refund service." \
  "React, Admin" \
  "implement/admin-refund-bulk" \
  "- Admins must approve or reject refunds in bulk." \
  "feat(admin): add bulk refund actions"

create_issue \
  "Implement: MobileHero swipe carousel" \
  "components/mobile/MobileHero.tsx" \
  "Add a touch-swipe hero carousel with pagination to the mobile landing page." \
  - Render a swipeable carousel of hero slides.
- Add pagination dots indicating the current slide.
- Support touch swipe and click navigation." \
  "React, Mobile" \
  "implement/mobile-hero-carousel" \
  "- The mobile hero must support touch-swipe with pagination." \
  "feat(mobile): add swipe carousel to mobile hero"

create_issue \
  "Implement: SettingsExportDataDownload" \
  "components/settings/ExportData.tsx" \
  "Trigger a GDPR-style account data export download from the settings page." \
  - Call the export data service to generate a user data package.
- Provide a download button linking to the generated file.
- Show a success/toast notification when ready." \
  "React, Settings" \
  "implement/settings-data-export" \
  "- Users must be able to download their account data export." \
  "feat(settings): add account data export download"

# --- ISSUE DEFINITIONS (91 to 105: Test Coverage) ---

create_issue \
  "Test: httpClient 401 interception" \
  "__tests__/services/httpClient.test.ts" \
  "Mock a 401 response and assert the auth token is removed and an auth callback fires instead of \`window.location.assign\`." \
  "- Mock axios to return a 401 response.
- Assert \`localStorage.removeItem('authToken')\` is called.
- Assert no \`window.location.assign\` occurs; assert an auth event fires." \
  "Jest, HTTP" \
  "test/http-client-401" \
  "- 401 interception must remove the token and fire a callback, not redirect." \
  "test(core): cover http client 401 handling"

create_issue \
  "Test: useOffline generation guard" \
  "__tests__/hooks/useOffline.test.ts" \
  "Simulate rapid online/offline transitions and assert no stale verification overwrites the current state." \
  "- Trigger offline, then online, then offline quickly.
- Resolve the first online check after the second offline.
- Assert \`isOnline\` is false and no stale true state leaks." \
  "Jest, Hooks" \
  "test/use-offline-guard" \
  "- Rapid network flapping must not overwrite state with a stale response." \
  "test(hooks): cover useoffline generation guard"

create_issue \
  "Test: TxTracker terminal-state debounce" \
  "components/wallet/__tests__/TxTracker.test.tsx" \
  "Fire a fast SUCCESS followed by a failure and assert the status does not flicker back to Pending." \
  "- Mock \`useTxTracker\` to return SUCCESS then FAILED rapidly.
- Render TxTracker and snapshot status transitions.
- Assert the UI never shows Pending after reaching terminal state." \
  "Jest, RTL" \
  "test/tx-tracker-debounce" \
  "- Terminal state transitions must not flicker backward to Pending." \
  "test(wallet): cover tx tracker terminal state debounce"

create_issue \
  "Test: PaymentLock invalid submission" \
  "components/escrow/__tests__/PaymentLock.test.tsx" \
  "Simulate pressing Enter with an invalid XLM amount and assert \`onLock\` is not called." \
  - Render PaymentLock with an invalid amount.
- Dispatch an Enter key on the form.
- Assert \`onLock\` was not invoked." \
  "Jest, RTL" \
  "test/payment-lock-invalid" \
  "- Invalid amount must not trigger \`onLock\` on Enter." \
  "test(escrow): block invalid payment lock submission"

create_issue \
  "Test: QRScanner permission-denied fallback" \
  "components/logistics/__tests__/QrScanner.test.tsx" \
  "Mock \`getUserMedia\` rejection and assert the 'Camera Permission Denied' fallback renders." \
  - Reject \`navigator.mediaDevices.getUserMedia\`.
- Render QrScanner and wait for the fallback.
- Assert the permission-denied message is present." \
  "Jest, RTL" \
  "test/qr-scanner-permission" \
  "- The UI must render a camera permission denied fallback when \`getUserMedia\` rejects." \
  "test(logistics): cover qr scanner permission fallback"

create_issue \
  "Test: OfflineBanner dismiss within 1s" \
  "components/ui/__tests__/OfflineBanner.test.tsx" \
  "Simulate reconnection and assert the banner unmounts within 1 second." \
  - Start offline, then go online.
- Use fake timers to advance 1 second.
- Assert the banner is no longer in the DOM." \
  "Jest, RTL" \
  "test/offline-banner-dismiss" \
  "- The banner must unmount within 1 second of reconnection." \
  "test(ui): cover offline banner auto-dismiss"

create_issue \
  "Test: Statistics skeleton parity" \
  "components/dashboard/__tests__/Statistics.test.tsx" \
  "Snapshot the skeleton loader block dimensions and compare them to the loaded card dimensions." \
  - Render Statistics in loading state and capture skeleton dimensions.
- Render Statistics with data and capture card dimensions.
- Assert skeleton and loaded heights match across breakpoints." \
  "Jest, RTL" \
  "test/statistics-skeleton" \
  "- Skeleton block dimensions must match the rendered cards." \
  "test(dashboard): cover statistics skeleton dimensions"

create_issue \
  "Test: AddressAutocomplete debounce" \
  "components/logistics/__tests__/AddressAutocomplete.test.tsx" \
  "Type rapidly into the autocomplete and assert only one API call fires after 300ms." \
  - Use fake timers and type multiple characters quickly.
- Assert the places API is called once after 300ms, not per keystroke." \
  "Jest, RTL" \
  "test/address-autocomplete-debounce" \
  "- Rapid typing must result in a single API call after the debounce wait." \
  "test(logistics): cover address autocomplete debounce"

create_issue \
  "Test: MultiSigApprovals aria-disabled" \
  "components/wallet/__tests__/MultiSigApprovals.test.tsx" \
  "When signatures are below the threshold, assert the approval button has \`aria-disabled=\"true\"\`." \
  - Render MultiSigApprovals with 1 of 2 signatures.
- Query the approval button and check \`aria-disabled\`.
- Assert it equals \`true\`." \
  "Jest, RTL" \
  "test/multisig-aria-disabled" \
  "- Below threshold, the button must announce aria-disabled and threshold status." \
  "test(wallet): cover multisig aria-disabled"

create_issue \
  "Test: FleetTable virtualization row count" \
  "components/fleet/__tests__/EnterpriseDashboard.test.tsx" \
  "Render 1000 fleet rows and assert only the viewport rows exist in the DOM." \
  - Render EnterpriseDashboard with 1000 mock rows.
- Count DOM row elements after virtualization.
- Assert only visible viewport rows (plus small buffer) are rendered." \
  "Jest, RTL" \
  "test/fleet-table-virtualization" \
  "- The DOM must only render viewport rows for a 1000-row table." \
  "test(fleet): cover table virtualization row count"

create_issue \
  "Test: GlobalSearch Escape closes" \
  "components/search/__tests__/GlobalSearch.test.tsx" \
  "Dispatch an \`Escape\` keydown and assert the command palette unmounts." \
  - Open GlobalSearch via Ctrl+K mock.
- Dispatch Escape keydown on the document.
- Assert the palette is no longer in the DOM." \
  "Jest, RTL" \
  "test/global-search-escape" \
  "- The Escape key must unmount the command palette." \
  "test(search): cover global palette escape close"

create_issue \
  "Test: CurrencySelector API-driven" \
  "components/layout/__tests__/CurrencySelector.test.tsx" \
  "Mock \`currencyRateService\` and assert the selector renders the returned fiat options." \
  - Mock the currency API to return NGN, USD, GBP.
- Render CurrencySelector.
- Assert all three options appear in the dropdown." \
  "Jest, RTL" \
  "test/currency-selector-api" \
  "- Currency options must render from the mocked API response." \
  "test(layout): cover currency selector api options"

create_issue \
  "Test: DisputeForm rejects empty evidence" \
  "components/escrow/__tests__/DisputeForm.test.tsx" \
  "Submit the dispute form with no evidence files attached and assert a validation error appears." \
  - Render DisputeForm with an empty evidence list.
- Click submit.
- Assert a validation error is shown and \`onSubmit\` is not called." \
  "Jest, RTL" \
  "test/dispute-form-empty-evidence" \
  "- Submission with no evidence must show a validation error." \
  "test(escrow): cover dispute form empty evidence"

create_issue \
  "Test: useAuth disconnect resets balance" \
  "__tests__/hooks/useAuth.test.ts" \
  "Disconnect the wallet and assert the wallet balance state is cleared." \
  - Mock an authenticated state with a balance.
- Call disconnect.
- Assert balance is reset to null/zero." \
  "Jest, Hooks" \
  "test/auth-disconnect-balance" \
  "- Wallet balance must clear on auth disconnect." \
  "test(hooks): cover auth disconnect balance reset"

create_issue \
  "Test: E2E checkout flow" \
  "cypress/e2e/escrow-checkout.cy.ts" \
  "Write a Cypress E2E test covering the full escrow checkout: lock, sign, and release." \
  - Visit the escrow payment page.
- Lock funds, sign with mock wallet, then release.
- Assert the final status is 'released'." \
  "Cypress, E2E" \
  "test/e2e-escrow-checkout" \
  "- E2E must complete the lock, sign, and release escrow flow." \
  "test(e2e): cover escrow checkout flow"

# --- ISSUE DEFINITIONS (106 to 120: Performance, Security, PWA, i18n, Ops) ---

create_issue \
  "Performance: Fleet table virtualization" \
  "components/fleet/EnterpriseDashboard.tsx" \
  "Replace \`.map()\` rendering with \`@tanstack/react-virtual\` so only viewport rows are in the DOM for 1000+ deliveries." \
  "- Install/confirm \`@tanstack/react-virtual\` is available.
- Replace the table \`.map()\` with a virtualizer.
- Verify scrolling stays at 60fps with large datasets." \
  "React, Performance" \
  "perf/fleet-table-virtualization" \
  "- The table must use @tanstack/react-virtual for 1000+ rows." \
  "perf(fleet): virtualize enterprise dashboard table"

create_issue \
  "Performance: Client-side image compression <500KB" \
  "components/logistics/ImageCapture.tsx" \
  "Wire \`browser-image-compression\` (already a dependency) into the delivery proof upload flow so images compress under 500KB." \
  "- Import \`imageCompression\` from \`browser-image-compression\`.
- Compress captured images before upload.
- Show a 'Compressing...' state during processing." \
  "React, Image Compression" \
  "perf/image-compression" \
  "- Uploaded proof images must be compressed under 500KB." \
  "perf(logistics): compress delivery proof images client-side"

create_issue \
  "Performance: Dashboard skeleton loaders" \
  "components/dashboard/RoiDashboard.tsx, components/dashboard/FleetAnalyticsDashboard.tsx" \
  "Add \`isLoading\` skeleton loaders to all dashboard pages that currently lack them." \
  - Add ChartSkeletonLoader to RoiDashboard and FleetAnalyticsDashboard.
- Show skeletons while data fetches, then swap in real charts.
- Match skeleton dimensions to final chart sizes." \
  "React, Performance" \
  "perf/dashboard-skeletons" \
  "- All dashboards must show skeleton loaders while fetching data." \
  "perf(dashboard): add skeleton loaders to roi and fleet analytics"

create_issue \
  "Performance: next/image priority for hero" \
  "components/landing/HeroSection.tsx" \
  "Add the \`priority\` prop to the hero image so Next.js preloads it for Largest Contentful Paint." \
  - Replace the hero \`\` with \`next/image\`.
- Add \`priority\` and appropriate \`width\`/\`height\`.
- Verify LCP improves in Lighthouse." \
  "Next.js, Performance" \
  "perf/hero-image-priority" \
  "- The hero image must use next/image priority for LCP." \
  "perf(landing): prioritize hero image loading"

create_issue \
  "Performance: Bundle audit" \
  "package.json" \
  "Audit dependencies and remove unused heavy packages (e.g., unused \`prismjs\` or \`lodash\`) and tree-shake remaining imports." \
  - Run \`pnpm list\` or \`why\` to find unused deps.
- Remove packages not imported anywhere in src.
- Verify build still succeeds and bundle shrinks." \
  "JavaScript, Bundling" \
  "perf/bundle-audit" \
  "- The bundle must drop unused heavy dependencies." \
  "perf(core): audit and remove unused bundle dependencies"

create_issue \
  "Security: authToken localStorage XSS review" \
  "lib/httpClient.ts" \
  "Evaluate storing \`authToken\` in \`localStorage\` (XSS risk) and migrate to \`httpOnly\` cookies or add XSS mitigations." \
  - Review how \`authToken\` is set and read in httpClient.
- Propose \`httpOnly\` cookie migration via backend set-cookie.
- If cookies aren't feasible, add CSP and sanitization mitigations." \
  "Security, Auth" \
  "security/auth-token-storage" \
  "- Auth token storage must mitigate XSS via httpOnly cookie or equivalent safeguards." \
  "security(auth): review localStorage token for XSS risk"

create_issue \
  "Security: Rate-limit API route handlers" \
  "app/api/*.route.ts" \
  "Add rate limiting to Next.js API route handlers to prevent brute-force and abuse." \
  - Choose an in-memory or upstash/redis rate limiter.
- Apply per-IP or per-user rate limits to sensitive routes (auth, payout, escrow).
- Return 429 with Retry-After when limits are exceeded." \
  "Security, API" \
  "security/api-rate-limiting" \
  "- API routes must enforce rate limits per client." \
  "security(api): add rate limiting to route handlers"

create_issue \
  "Security: CSP headers" \
  "next.config.ts" \
  "Add a \`Content-Security-Policy\` header to restrict script, style, and image sources." \
  - Configure \`headers()\` in next.config.ts.
- Add CSP directives for \`script-src\`, \`style-src\`, \`img-src\`, \`connect-src\`.
- Verify the app still loads all assets under the new policy." \
  "Security, Headers" \
  "security/csp-headers" \
  "- The application must serve Content-Security-Policy headers." \
  "security(core): add content security policy headers"

create_issue \
  "Security: Sanitize stellarExplorerUrl" \
  "components/wallet/TxTracker.tsx" \
  "Validate the \`stellarExplorerUrl\` before rendering it as an external \`target="_blank"\` link to prevent open-redirect/XSS." \
  - Validate the URL is a known Stellar explorer domain.
- Block or sanitize non-explorer URLs.
- Keep \`rel="noopener noreferrer"\` on the link." \
  "Security, XSS" \
  "security/explorer-url-sanitize" \
  "- External explorer links must be validated before opening." \
  "security(ui): sanitize stellar explorer urls"

create_issue \
  "PWA: manifest.json + service-worker registration" \
  "public/, next.config.ts" \
  "Register the existing \`public/service-worker.js\` and add a \`manifest.json\` so the app can be installed as a PWA." \
  - Add \`public/manifest.json\` with app name, icons, start_url.
- Register the service worker in \`app/layout.tsx\` or \`app/page.tsx\`.
- Verify the install prompt appears in supported browsers." \
  "PWA, Offline" \
  "pwa/manifest-and-sw" \
  "- The app must register a service worker and serve a web app manifest." \
  "feat(pwa): add manifest and service worker registration"

create_issue \
  "PWA: Offline fallback page" \
  "app/offline.tsx" \
  "Add a Next.js \`app/offline.tsx\` fallback for offline navigation." \
  - Create \`app/offline.tsx\` with a branded offline UI.
- Ensure Next.js serves it when the user is offline.
- Test by disabling network and navigating." \
  "PWA, Offline" \
  "pwa/offline-page" \
  "- Offline navigation must render a fallback page." \
  "feat(pwa): add offline fallback page"

create_issue \
  "i18n: Nigerian language support" \
  "contexts/LanguageContext.tsx" \
  "Add Pidgin, Hausa, Yoruba, and Igbo dialect support with a language selection dropdown in the Help Center." \
  - Build a translation dictionary for each Nigerian dialect.
- Add a language dropdown to HelpCenter.tsx.
- Persist the selected language in localStorage." \
  "i18n, Localization" \
  "i18n/nigerian-languages" \
  "- The help center must toggle between English and Nigerian dialects." \
  "feat(i18n): add nigerian language translations"

create_issue \
  "i18n: Extract hardcoded strings" \
  "lib/languageService.ts" \
  "Centralize all FAQ and support UI strings into a JSON dictionary for translation." \
  - Audit components for hardcoded English strings.
- Move strings into \`lib/languageService.ts\` JSON keys.
- Replace hardcoded strings with \`t('key')\` calls." \
  "i18n" \
  "i18n/string-dictionary" \
  "- All UI strings must be extracted to a central dictionary." \
  "feat(i18n): extract hardcoded strings to dictionary"

create_issue \
  "Ops: Dependabot / renovate config" \
  ".github/" \
  "Add automated dependency update PRs via Dependabot or Renovate." \
  - Add \`.github/dependabot.yml\` or \`renovate.json\`.
- Configure weekly dependency checks for pnpm packages.
- Verify PRs are created on schedule." \
  "Ops, Dependencies" \
  "ops/dependabot" \
  "- The repository must receive automated dependency update PRs." \
  "ops(ci): add dependabot configuration"

create_issue \
  "Ops: CODEOWNERS + issue templates" \
  ".github/CODEOWNERS, .github/ISSUE_TEMPLATE/" \
  "Add a \`CODEOWNERS\` file and GitHub issue templates for bugs and features." \
  - Create \`.github/CODEOWNERS\` mapping paths to team owners.
- Add \`bug_report.yml\` and \`feature_request.yml\` templates.
- Link templates in the repo contribution docs." \
  "Ops, Governance" \
  "ops/codeowners-templates" \
  "- The repository must have issue templates and CODEOWNERS." \
  "ops(github): add codeowners and issue templates"

echo -e "\n✅ All 120 Fix, Test, and Enhancement issues successfully generated!"

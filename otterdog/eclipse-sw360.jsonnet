local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

local customRuleset(name) = 
  orgs.newRepoRuleset(name) {
    bypass_actors+: [
      "@eclipse-sw360/technology-sw360-project-leads"
    ],
    include_refs+: [
      std.format("refs/heads/%s", name),
    ],
    required_pull_request+: {
      required_approving_review_count: 1,
      requires_last_push_approval: true,
      requires_review_thread_resolution: true,
      dismisses_stale_reviews: true,
    },
    requires_linear_history: true,
  };

orgs.newOrg('eclipse-sw360') {
  settings+: {
    description: "SW360 Portal Organization",
    name: "Eclipse SW360",
    web_commit_signoff_required: true,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  _repositories+:: [
    orgs.newRepo('sw360') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      delete_branch_on_merge: false,
      dependabot_security_updates_enabled: true,
      description: "SW360 project",
      has_discussions: true,
      homepage: "https://www.eclipse.org/sw360/",
      web_commit_signoff_required: true,
      rulesets: [
        customRuleset("main") {
          required_status_checks+: {
            status_checks+: [
              "build"
            ]
          }
        }
      ]
    },
    orgs.newRepo('sw360-frontend') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      delete_branch_on_merge: false,
      description: "SW360 Frontend Project",
      has_discussions: true,
      web_commit_signoff_required: true,
      rulesets: [
        customRuleset("main") {
          required_status_checks+: {
            status_checks+: [
              "build"
            ]
          }
        }
      ]
    },
    orgs.newRepo('sw360.website') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "sw360 website",
      homepage: "https://www.eclipse.org/sw360/",
      topics+: [
        "eclipse"
      ],
      web_commit_signoff_required: true,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          allows_force_pushes: false,
          bypass_pull_request_allowances+: [
            "@eclipse-sw360/technology-sw360-project-leads"
          ],
          dismisses_stale_reviews: true,
          required_approving_review_count: 1,
          requires_commit_signatures: true,
          requires_conversation_resolution: true,
          requires_strict_status_checks: false,
        },
      ],
    },
    orgs.newRepo('sw360.website.published') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      web_commit_signoff_required: true,
      workflows+: {
        enabled: false,
      },
    },
  ],
}

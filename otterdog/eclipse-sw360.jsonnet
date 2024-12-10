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
      dismisses_stale_reviews: true,
      requires_code_owner_review: true,
      requires_last_push_approval: true,
      requires_review_thread_resolution: true
    },
    requires_linear_history: true,

  };

orgs.newOrg('eclipse-sw360') {
  settings+: {
    description: "SW360 Portal Organization",
    name: "Eclipse SW360",
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  secrets+: [
    orgs.newOrgSecret('RENOVATE_TOKEN') {
      selected_repositories+: [
        "sw360",
        "sw360-frontend"
      ],
      value: "pass:bots/technology.sw360/github.com/renovate-token",
      visibility: "selected"
    }
  ],
  _repositories+:: [
    orgs.newRepo('sw360') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      delete_branch_on_merge: true,
      dependabot_security_updates_enabled: true,
      description: "SW360 project",
      has_discussions: true,
      homepage: "https://www.eclipse.org/sw360/",
      rulesets: [
        customRuleset("main") {
          required_status_checks+: {
            status_checks+: [
              "Build and Test"
            ]
          }
        }
      ]
    },
    orgs.newRepo('sw360-frontend') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      delete_branch_on_merge: true,
      description: "SW360 Frontend Project",
      has_discussions: true,
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
      delete_branch_on_merge: true,
      description: "sw360 website",
      homepage: "https://www.eclipse.org/sw360/",
      topics+: [
        "eclipse"
      ],
      has_discussions: false,
      rulesets: [
        customRuleset("main") {
          required_status_checks+: {
            status_checks+: [
              "Build and Archive"
            ]
          }
        }
      ]
    },
    orgs.newRepo('sw360.website.published') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      workflows+: {
        enabled: false,
      },
    },
  ],
} + {
  # snippet added due to 'https://github.com/EclipseFdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}
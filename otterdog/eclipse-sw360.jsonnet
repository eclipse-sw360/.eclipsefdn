local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-sw360') {
  settings+: {
    description: "SW360 Portal Organization",
    name: "Eclipse SW360",
    web_commit_signoff_required: false,
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
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://hooks.waffle.io/api/projects/5ae046b8699787001ba21c1d/sources/5ae046b8699787001ba21c1c/receive') {
          content_type: "json",
          events+: [
            "*"
          ],
          secret: "********",
        },
        orgs.newRepoWebhook('https://notify.travis-ci.org') {
          events+: [
            "create",
            "delete",
            "issue_comment",
            "member",
            "public",
            "pull_request",
            "push",
            "repository"
          ],
        },
      ],
    },
    orgs.newRepo('sw360-frontend') {
      allow_merge_commit: true,
      allow_squash_merge: false,
      delete_branch_on_merge: false,
      description: "Frontend",
      has_discussions: true,
      web_commit_signoff_required: false,
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          allows_force_pushes: true,
          bypass_pull_request_allowances+: [
            "@eclipse-sw360/technology-sw360-project-leads"
          ],
          dismisses_stale_reviews: true,
          required_approving_review_count: 0,
          requires_commit_signatures: true,
          requires_conversation_resolution: true,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
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
      web_commit_signoff_required: false,
    },
    orgs.newRepo('sw360.website.published') {
      allow_merge_commit: true,
      allow_update_branch: false,
      delete_branch_on_merge: false,
      web_commit_signoff_required: false,
      workflows+: {
        enabled: false,
      },
    },
  ],
}

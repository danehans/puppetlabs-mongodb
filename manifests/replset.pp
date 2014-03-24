# Wrapper class useful for hiera based deployments

class mongodb::replset(
  $sets = undef,
  $auth = false
) {

  if $sets {
    if $auth {
      create_resources(mongodb_auth_replset, $sets)
    } else {
      create_resources(mongodb_replset, $sets)
    }
  }
}

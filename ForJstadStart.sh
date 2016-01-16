#!/bin/sh
policy=${HOME}/.jstatd.all.policy
[ -r ${policy} ] || cat >${policy} <<'POLICY'
grant codebase "file:/usr/lib/jvm/java-7-oracle/lib/tools.jar" {
permission java.security.AllPermission;
};
POLICY
jstatd -J-Djava.security.policy=${policy} -J-Djava.rmi.server.hostname=xx.xx.xx.xx -J-Djava.rmi.server.logCalls=true

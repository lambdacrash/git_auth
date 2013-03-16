mod_git_auth.la: mod_git_auth.slo
	$(SH_LINK) -rpath $(libexecdir) -module -avoid-version  mod_git_auth.lo
DISTCLEAN_TARGETS = modules.mk
shared =  mod_git_auth.la

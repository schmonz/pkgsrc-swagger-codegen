# $NetBSD: Makefile,v 1.9 2023/06/12 19:13:38 schmonz Exp $

DISTNAME=		swagger-codegen-3.0.46
CATEGORIES=		devel
MASTER_SITES=		${MASTER_SITE_GITHUB:=swagger-api/}
GITHUB_TAG=		v${PKGVERSION_NOREV}

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://swagger.io/tools/swagger-codegen/
COMMENT=		Generate clients, server stubs, and docs from an OpenAPI spec
LICENSE=		apache-2.0

BUILD_DEPENDS+=		apache-maven>=3.6.2:../../devel/apache-maven

USE_JAVA2=		17	# 11 would be fine

CHECK_PORTABILITY_SKIP=	samples/client/petstore/swift*/*/*/*/*/*/*.sh

AUTO_MKDIRS=		yes

# XXX needs a 'java-modules.mk' to checksum downloaded dependencies

do-build:
	cd ${WRKSRC} && mvn clean package

do-install:
	${INSTALL_DATA} ${WRKSRC}/modules/swagger-codegen-cli/target/swagger-codegen-cli.jar \
		${DESTDIR}${PREFIX}/share/${PKGBASE}/swagger-codegen-cli.jar
	${ECHO} '#!${SH}' > \
		${DESTDIR}${PREFIX}/bin/swagger-codegen
	${ECHO} 'exec java -jar ${PREFIX}/share/${PKGBASE}/swagger-codegen-cli.jar "$$@"' >> \
		${DESTDIR}${PREFIX}/bin/swagger-codegen
	${CHMOD} +x ${DESTDIR}${PREFIX}/bin/swagger-codegen

.include "../../mk/java-vm.mk"
.include "../../mk/bsd.pkg.mk"

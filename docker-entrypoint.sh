#!/bin/bash

echo "preparing ..."
echo "set PUID to ${PUID}"
usermod -u ${PUID} ${USER}
echo "set PGID to ${PGID}"
usermod -g ${PGID} ${USER}
echo "set umask to ${UMASK}"
umask ${UMASK}

#echo "checking for user file ..."
#if [ !  "$(ls -A  "$DIR" )" ];
#       then echo "empty" ;
#fi

echo "fixing permissions ..."
chown -R ${PUID}:${PGID} ${THELOUNGE_HOME}

echo "starting thelounge ..."
su ${USER} -c "thelounge start"

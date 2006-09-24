#!/bin/bash
# $Id$
#
# Authors:
#      Jeff Buchbinder <jeff@freemedsoftware.org>
#
# Copyright (C) 1999-2006 FreeMED Software Foundation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

echo "\$Id$"
echo "(c) 2006 by the FreeMED Software Foundation"
echo " "

if [ ! -f ./scripts/tsmarty2c.php ]; then
	echo "Needs to be run from the FreeMED root directory."
	exit
fi

for UI in ui/*; do

	echo " * Processing interface ${UI}"

	echo -n " - Creating translation catalog ... "
	php ./scripts/tsmarty2c.php ${UI}/view | xgettext --language=C - - > "locale/$(basename "${UI}").po"
	echo "[done]"

	echo " "

done

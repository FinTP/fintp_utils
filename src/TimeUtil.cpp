/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <mailto:office@allevo.ro>, www.allevo.ro.
*/

#include "StringUtil.h"
#include "TimeUtil.h"

using namespace FinTP;

double TimeUtil::Compare( const string& time1, const string& time2, const string& format )
{
	if( time1.length() != time2.length() )
		return false;

	struct tm timeptr1;
	struct tm timeptr2;

	timeptr1.tm_isdst = 0;
	timeptr2.tm_isdst = 0;

	unsigned int i=0, j=0;
	while( j < time1.length() )
	{
		if( format[i] == '%' )
		{
			if( format[ i+1 ] == 'Y' )
			{
				timeptr1.tm_year = StringUtil::ParseInt( time1.substr( j, 4 ) ) - 1900;
				timeptr2.tm_year = StringUtil::ParseInt( time2.substr( j, 4 ) ) - 1900;
				j+=4;
			}
			else if( format[ i+1 ] == 'm' )
			{
				timeptr1.tm_mon = StringUtil::ParseInt( time1.substr( j, 2 ) ) - 1;
				timeptr2.tm_mon = StringUtil::ParseInt( time2.substr( j, 2 ) ) - 1;
				j+=2;
			}
			else if( format[ i+1 ] == 'd' )
			{
				timeptr1.tm_mday = StringUtil::ParseInt( time1.substr( j, 2 ) );
				timeptr2.tm_mday = StringUtil::ParseInt( time2.substr( j, 2 ) );
				j+=2;
			}
			else if( format[ i+1 ] == 'H' )
			{
				timeptr1.tm_hour = StringUtil::ParseInt( time1.substr( j, 2 ) );
				timeptr2.tm_hour = StringUtil::ParseInt( time2.substr( j, 2 ) );
				j+=2;
			}
			else if( format[ i+1 ] == 'M' )
			{
				timeptr1.tm_min = StringUtil::ParseInt( time1.substr( j, 2 ) );
				timeptr2.tm_min = StringUtil::ParseInt( time2.substr( j, 2 ) );
				j+=2;
			}
			else if( format[ i+1 ] == 'S' )
			{
				timeptr1.tm_sec = StringUtil::ParseInt( time1.substr( j, 2 ) );
				timeptr2.tm_sec = StringUtil::ParseInt( time2.substr( j, 2 ) );
				j+=2;
			}
			i+=2;
		}
		else
		{
			i++;
			j++;
		}
	}

	time_t time1t = mktime( &timeptr1 );
	time_t time2t = mktime( &timeptr2 );

	return difftime( time2t, time1t );
}

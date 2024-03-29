/***************************************************************************
			  codegenerator.cpp  -  description
			     -------------------
    begin		 :
    copyright		 : (C) 2007-2010 by Andre Simon
    email		 : andre.simon1@gmx.de
 ***************************************************************************/

/*
This file is part of ANSIFilter.

ANSIFilter is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ANSIFilter is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ANSIFilter.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "codegenerator.h"

#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif

#include <fstream>
#include "version.h"

#include "htmlgenerator.h"
#include "rtfgenerator.h"
#include "plaintextgenerator.h"
#include "texgenerator.h"
#include "latexgenerator.h"

using namespace std;

namespace ansifilter
{

    //TODO Farben aus basic16 Tabelle verwenden
    string CodeGenerator::ColorBlack	= "#000000";
    string CodeGenerator::ColorRed	= "#800000";
    string CodeGenerator::ColorGreen	= "#008000";
    string CodeGenerator::ColorYellow	= "#808000";
    string CodeGenerator::ColorBlue	= "#000080";
    string CodeGenerator::ColorMagenta  = "#800080";
    string CodeGenerator::ColorCyan	= "#008080";
    string CodeGenerator::ColorWhite	= "#c0c0c0";

    CodeGenerator * CodeGenerator::getInstance(OutputType type)
    {
	CodeGenerator* generator=NULL;
	switch (type)
	{
	    case TEXT:
	    generator = new PlaintextGenerator();
	    break;
	    case HTML:
	    generator = new HtmlGenerator();
	    break;
	    case LATEX:
	    generator = new LaTeXGenerator();
	    break;
	    case TEX:
	    generator = new TeXGenerator();
	    break;
	    case RTF:
	    generator = new RtfGenerator();
	    break;
	    default:
	    break;
	}
	return generator;
    }

    CodeGenerator::CodeGenerator(ansifilter::OutputType type)
	    :in(NULL),
	    out(NULL),
	    encoding("none"),
	    docTitle("Source file"),
	    fragmentOutput(false),
	    font("Courier New"),
	    fontSize("10pt"),
	    outputType(type),
	    ignoreFormatting(false),
	    readAfterEOF(false)
    {
	elementStyle.setFgColour("#000000");
	elementStyle.setBgColour("#ffffff");
    }

    CodeGenerator::~CodeGenerator()
    {}

    void CodeGenerator::setFragmentCode(bool flag)
    {
	fragmentOutput=flag;
    }

    bool CodeGenerator::getFragmentCode()
    {
	return fragmentOutput;
    }

    void CodeGenerator::setFont(const string& s)
    {
	font = s;
    }

    void CodeGenerator::setFontSize(const string& s)
    {
	fontSize = s ;
    }

    void CodeGenerator::setTitle(const string & title)
    {
	if (!title.empty())
	    docTitle= title;
    }

    string CodeGenerator::getTitle()
    {
	return docTitle;
    }

    void CodeGenerator::setEncoding(const string& encodingName)
    {
	encoding = encodingName;
    }

    ParseError CodeGenerator::generateFile (const string &inFileName,
					    const string &outFileName)
    {

	ParseError error=PARSE_OK;

	in = (inFileName.empty()? &cin :new ifstream (inFileName.c_str()));


	if (!in->fail() && error==PARSE_OK)
	{
	    out = (outFileName.empty()? &cout :new ofstream (outFileName.c_str()));
	    if ( out->fail())
	    {
		error=BAD_OUTPUT;
	    }
	}

	if ( in->fail())
	{
	    error=BAD_INPUT;
	}

	if (error==PARSE_OK)
	{
	    if (! fragmentOutput)
	    {
		*out << getHeader();
	    }

	    printBody();

	    if (! fragmentOutput)
	    {
		*out << getFooter();
	    }
	}

	if (!outFileName.empty())
	{
	    delete out;
	    out=NULL;
	}
	if (!inFileName.empty())
	{
	    delete in;
	    in=NULL;
	}
	return error;
    }

    string CodeGenerator::generateString(const string &input)
    {
	in = new istringstream (input);
	out = new ostringstream ();

	if ( in->fail() || out->fail())
	{
	    return "";
	}

	if (! fragmentOutput)
	{
	    *out << getHeader();
	}

	printBody();

	if (! fragmentOutput)
	{
	    *out << getFooter();
	}

	string result = static_cast<ostringstream*>(out)->str();

	delete out;
	out=NULL;
	delete in;
	in=NULL;

	return result;
    }

    string CodeGenerator::generateStringFromFile(const string &inFileName)
    {

	in = new ifstream (inFileName.c_str());
	out = new ostringstream ();

	if ( in->fail() || out->fail())
	{
	    return "";
	}

	if (! fragmentOutput)
	{
	    *out << getHeader();
	}

	printBody();

	if (! fragmentOutput)
	{
	    *out << getFooter();
	}

	string result = static_cast<ostringstream*>(out)->str();

	delete out;
	out=NULL;
	delete in;
	in=NULL;

	return result;
    }

    /** for Notepad++ Plugin
	TODO if Plugin gets updated more often, change generate methods
	     to call a private mwthod which handles writing from/ to files or strings
	     as needed
    */
    ParseError CodeGenerator::generateFileFromString (const string &sourceStr,
	    const string &outFileName,
	    const string &title)
    {
	ParseError error=PARSE_OK;

	in = new istringstream (sourceStr);
	if (!in->fail())
	{
	    out = (outFileName.empty()? &cout :new ofstream (outFileName.c_str()));
	    if ( out->fail())
	    {
		error=BAD_OUTPUT;
	    }
	}

	if ( in->fail())
	{
	    error=BAD_INPUT;
	}

	if (error==PARSE_OK)
	{

	    if (! fragmentOutput)
	    {
		*out << getHeader();
	    }

	    printBody();

	    if (! fragmentOutput)
	    {
		*out << getFooter();
	    }
	}

	if (!outFileName.empty())
	{
	    delete out;
	    out=NULL;
	}

	delete in;
	in=NULL;

	return error;
    }

    bool CodeGenerator::parseSequence(const string& line, size_t begin, size_t end)
    {
	if (end-begin>2 && line[begin]!=0x1b && line[begin+1]!=0x5b)
	{
	    return false;
	}
	int ansiCode=0;
	int colorCode=0;
	unsigned char colorValues[3]={0};
	char colorString[10]={0};

	string codes=line.substr(begin+2, end-begin-2);
	vector<string> codeVector = StringTools::splitString(codes, ';');
	if (codes.empty()){ // fix empty grep --color ending sequence
	  elementStyle.setReset(true);
	  return true;
	}
	
	std::vector<std::string>::iterator itVectorData = codeVector.begin();
	while( itVectorData != codeVector.end())
	{
	    StringTools::str2num<int>(ansiCode, *(itVectorData), std::dec);
	    elementStyle.setReset(false);

	    switch (ansiCode)
	    {
		case 0: //Reset
		elementStyle.setReset(true);
		break;
		case 1: //Bold
		elementStyle.setBold(true);
		break;
		case 2: //Faint
		break;

		case 3: //italic
		elementStyle.setItalic(true);
		break;

		case 5: //Blink
		case 6: //Blink fast
		elementStyle.setBlink(true);
		break;

		case 8: // Conceal
		elementStyle.setConceal(true);
		break;

		case 4:// Underline Single
		case 21: // Underline double
		elementStyle.setUnderline(true);
		break;

		case 7: // image negative
		elementStyle.imageMode(true);
		break;

		case 22: // not bold, not faint
		elementStyle.setBold(false);
		break;

		case 24: //no underline
		elementStyle.setUnderline(false);
		break;

		case 25: //no blink
		elementStyle.setBlink(false);
		break;

		case 27: // image positive
		elementStyle.imageMode(false);
		break;

		case 28: // Reveal
		elementStyle.setConceal(false);
		break;

		case 30:
		elementStyle.setFgColour(ColorBlack);
		break;
		case 31:
		elementStyle.setFgColour(ColorRed);
		break;
		case 32:
		elementStyle.setFgColour(ColorGreen);
		break;
		case 33:
		elementStyle.setFgColour(ColorYellow);
		break;
		case 34:
		elementStyle.setFgColour(ColorBlue);
		break;
		case 35:
		elementStyle.setFgColour(ColorMagenta);
		break;
		case 36:
		elementStyle.setFgColour(ColorCyan);
		break;
		case 37:
		elementStyle.setFgColour(ColorWhite);
		break;
		case 38: // xterm 256 foreground color mode \033[38;5;<color>

		itVectorData++;
		if (itVectorData == codeVector.end()) break;

		if(*(itVectorData)!="5") break;

		itVectorData++;
		if (itVectorData == codeVector.end()) break;

		StringTools::str2num<int>(colorCode, *(itVectorData), std::dec);
		xterm2rgb((unsigned char)colorCode, colorValues);
		sprintf(colorString, "#%02x%02x%02x",
			colorValues[0], colorValues[1], colorValues[2]);
		elementStyle.setFgColour(colorString);
		break;
		case 39:
		elementStyle.setReset(true);
		break;

		case 40:
		elementStyle.setBgColour(ColorBlack);
		break;
		case 41:
		elementStyle.setBgColour(ColorRed);
		break;
		case 42:
		elementStyle.setBgColour(ColorGreen);
		break;
		case 43:
		elementStyle.setBgColour(ColorYellow);
		break;
		case 44:
		elementStyle.setBgColour(ColorBlue);
		break;
		case 45:
		elementStyle.setBgColour(ColorMagenta);
		break;
		case 46:
		elementStyle.setBgColour(ColorCyan);
		break;
		case 47:
		elementStyle.setBgColour(ColorWhite);
		break;

		case 48:  // xterm 256 background color mode \033[48;5;<color>

		itVectorData++;
		if (itVectorData == codeVector.end()) break;

		if(*(itVectorData)!="5") break;

		itVectorData++;
		if (itVectorData == codeVector.end()) break;

		 StringTools::str2num<int>(colorCode, *(itVectorData), std::dec);

		 xterm2rgb((unsigned char)colorCode, colorValues);
		sprintf(colorString, "#%02x%02x%02x",
			colorValues[0], colorValues[1], colorValues[2]);
		elementStyle.setBgColour(colorString);
		break;

		case 49:
		
		elementStyle.setReset(true);
		break;
	    }

	    if (ansiCode>=30 and ansiCode <40)
		elementStyle.setFgColourID(ansiCode-30);
	    if (ansiCode>=40 and ansiCode <50)
		elementStyle.setBgColourID(ansiCode-40);

	    if (itVectorData != codeVector.end()) itVectorData++;
	}

	return true;
    }

    ////////////////////////////////////////////////////////////////////////////

    void CodeGenerator::processRootState()
    {

	if (readAfterEOF && in!=&cin){
	   in->seekg (0, ios::end);
	   // output the last few lines or the complete file if not too big
	   if (in->tellg()>51200) {
	       in->seekg (-512, ios::end);
	       // output complete lines, ignore first line fragment
	       in->ignore(512, '\n');
	   } else {
	       in->seekg (0, ios::beg); // output complete file
	   }
	}

	string line;
	size_t i=0;
	bool tagOpen=false;
	while (true)
	{
	    if (!getline(*in, line))
	    {
		// imitate tail bahaviour, continue to read after EOF
		if (readAfterEOF)
		{
		    out->flush();
		    in->clear();
#ifdef WIN32
		    Sleep(250);
#else
		    sleep(1);
#endif
		}
		else
		{
		    //todo hier position merken, in der gui periodisch den dateizeiger auf diesen wert setzen und den neuen code einlesen
		    break;
		}
	    }
	    else
	    {
		i=0;
		size_t seqEnd=string::npos;
		while (i <line.length() )
		{
		    if (line[i]==0x1b)
		    {
		      // fix grep --colour .[K (1b 5b 4b) sequences
		      if (line.length()>i+2 && line[i+2]==0x4b){
			  seqEnd=i+2;
		      } else {

			  seqEnd=line.find_first_of('m', i+1);

			  //TODO vor ; das hier anfangen xterm: ^[]0;~^G^M^M
			  // http://www.mit.edu/afs/athena/system/x11r4/src/mit/clients/xterm/ctlseq2.txt
			  if (seqEnd==string::npos) {
			      if (line[i+1]==']') seqEnd=line.find(0x07, i+1);
			  }
			  if (seqEnd==string::npos) seqEnd=line.find(';', i+1);
			  if (seqEnd==string::npos) seqEnd=line.find('h', i+1);

			  if (!ignoreFormatting && seqEnd!=string::npos)
			  {
			      if (!elementStyle.isReset()){
				  *out <<getCloseTag();
				  tagOpen=false;
			      }
			      parseSequence(line, i, seqEnd);
			      if (!elementStyle.isReset()) {
				  *out <<getOpenTag();
				  tagOpen=true;
			      }
			  }
			}
			i= 1+ ((seqEnd!=string::npos)?seqEnd:i);
		    }
		    else
		    {
			*out << maskCharacter(line[i]);
			++i;
		    }
		}
		*out << newLineTag;
	    }
	}
	if (tagOpen){
		*out <<getCloseTag();
	}
	out->flush();
    }


/* the following functions are based on Wolfgang Frischs xterm256 converter utility:
   http://frexx.de/xterm-256-notes/
*/
void CodeGenerator::xterm2rgb(unsigned char color, unsigned char* rgb)
{
      // 16 basic colors
      if(color<16)
      {
	      rgb[0] = basic16[color][0];
	      rgb[1] = basic16[color][1];
	      rgb[2] = basic16[color][2];
      }

      // color cube color
      if(color>=16 && color<=232)
      {
	      color-=16;
	      rgb[0] = valuerange[(color/36)%6];
	      rgb[1] = valuerange[(color/6)%6];
	      rgb[2] = valuerange[color%6];
      }

      // gray tone
      if(color>232 /* && color<255*/)
      {
	      rgb[0]=rgb[1]=rgb[2] = 8+(color-232)*0x0a;
      }
}

 const unsigned char CodeGenerator::valuerange[] = { 0x00, 0x5F, 0x87, 0xAF, 0xD7, 0xFF };

 const unsigned char CodeGenerator::basic16[16][3] =
{
      { 0x00, 0x00, 0x00 }, // 0
      { 0xCD, 0x00, 0x00 }, // 1
      { 0x00, 0xCD, 0x00 }, // 2
      { 0xCD, 0xCD, 0x00 }, // 3
      { 0x00, 0x00, 0xEE }, // 4
      { 0xCD, 0x00, 0xCD }, // 5
      { 0x00, 0xCD, 0xCD }, // 6
      { 0xE5, 0xE5, 0xE5 }, // 7
      { 0x7F, 0x7F, 0x7F }, // 8
      { 0xFF, 0x00, 0x00 }, // 9
      { 0x00, 0xFF, 0x00 }, // 10
      { 0xFF, 0xFF, 0x00 }, // 11
      { 0x5C, 0x5C, 0xFF }, // 12
      { 0xFF, 0x00, 0xFF }, // 13
      { 0x00, 0xFF, 0xFF }, // 14
      { 0xFF, 0xFF, 0xFF }  // 15
};

}

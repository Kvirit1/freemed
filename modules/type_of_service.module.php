<?php
  // $Id$
  // note: type of service (TOS) database module
  // code: adam b (gdrago23@yahoo.com) -- modified a lot
  // lic : GPL, v2

if (!defined("__TYPE_OF_SERVICE_MODULE_PHP__")) {

define (__TYPE_OF_SERVICE_MODULE_PHP__, true);

class typeOfServiceMaintenance extends freemedMaintenanceModule {

	var $MODULE_NAME = "Type of Service Maintenance";
	var $MODULE_VERSION = "0.1";

	var $record_name = "Type of Service";
	var $table_name  = "tos";
	var $order_field = "tosname,tosdescrip";

	var $variables = array (
			"tosname",
			"tosdescrip",
			"tosdtadd",
			"tosdtmod"
	);

	function typeOfServiceMaintenance () {
		// run constructor
		$this->freemedMaintenanceModule();
		global $tosdtmod;
		$tosdtmod = $GLOBALS["cur_date"];
	} // end constructor typeOfServiceMaintenance	

	function view () {
		reset ($GLOBALS);
		while (list($k, $v)=each($GLOBALS)) global $$k;

		echo freemed_display_itemlist (
			$sql->query("SELECT tosname,tosdescrip,id FROM ".$this->table_name.
				" ORDER BY ".prepare($this->order_field)),
			$this->page_name,
			array (
				_("Code") => "tosname",
				_("Description") => "tosdescrip"
			),
			array ("", _("NO DESCRIPTION")), "", "t_page"
		);
	} // end function module->view

	function form () {
		reset ($GLOBALS);
		while (list($k, $v)=each($GLOBALS)) global $$k;
  		if ($action=="modform") { 
    		$result = $sql->query("SELECT tosname,tosdescrip FROM $this->table_name
				WHERE ( id = '$id' )");
			$r = $sql->fetch_array($result); // dump into array r[]
			extract ($r);
		} // if loading values

		// display itemlist first
		$this->view ();

		echo "
			<FORM ACTION=\"$this->page_name\" METHOD=POST>
			<INPUT TYPE=HIDDEN NAME=\"tosdtadd\"".prepare($cur_date)."\">
			<INPUT TYPE=HIDDEN NAME=\"module\" VALUE=\"".prepare($module)."\">
			<INPUT TYPE=HIDDEN NAME=\"action\" VALUE=\"".
			($action=="modform" ? "mod" : "add")."\">";
		if ($action=="modform")
			echo "<INPUT TYPE=HIDDEN NAME=\"id\" VALUE=\"".prepare($id)."\">";

		echo "
			<TABLE WIDTH=\"100%\" BORDER=0 CELLPADDING=2 CELLSPACING=2>
			<TR><TD ALIGN=RIGHT>
			 <$STDFONT_B>"._("Type of Service")." : <$STDFONT_E>
			</TD><TD ALIGN=LEFT>
			 <INPUT TYPE=TEXT NAME=\"tosname\" SIZE=20 MAXLENGTH=75
 			  VALUE=\"".prepare($tosname)."\">
			</TD></TR>

			<TR><TD ALIGN=RIGHT>
			 <$STDFONT_B>"._("Description")." : <$STDFONT_E>
			</TD><TD ALIGN=LEFT>
			 <INPUT TYPE=TEXT NAME=\"tosdescrip\" SIZE=25 MAXLENGTH=200
			  VALUE=\"".prepare($tosdescrip)."\">
			</TD></TR>

			<TR><TD ALIGN=CENTER COLSPAN=2>
			 <INPUT TYPE=SUBMIT VALUE=\"".(
			 ($action=="modform") ? _("Modify") : _("Add"))."\">
			 <INPUT TYPE=RESET  VALUE=\""._("Remove Changes")."\">
			 </FORM>
			</TD></TR>
			</TABLE>
		";
		if ($action=="modform") echo "
			<P>
			<CENTER><$STDFONT_B>
			<A HREF=\"$this->page_name?$_auth&module=$module&action=view\"
			>"._("Abandon Modification")."</A>
			<$STDFONT_E></CENTER>
			";
	} // end function typeOfServiceMaintenance->form

} // end of class typeOfServiceMaintenance

register_module ("typeOfServiceMaintenance");

} // end of "if defined"

?>

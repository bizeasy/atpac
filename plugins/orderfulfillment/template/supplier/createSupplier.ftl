
<link href="<@ofbizContentUrl>/images/jquery/plugins/steps/jquery.steps.css</@ofbizContentUrl>" rel="stylesheet">
<script type="text/javascript" src="<@ofbizContentUrl>/images/jquery/plugins/steps/jquery.steps.js</@ofbizContentUrl>"></script>


<script type="application/javascript">
	function validateEmail(email) { 
    	var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    	return re.test(email);
	} 
	
    $(document).ready(function(){
      	      $("#wizard-2").steps({
                headerTag: "h3",
                bodyTag: "section",
                transitionEffect: "slideLeft",
                onStepChanging: function (event, currentIndex, newIndex)
                {	
                	if(currentIndex == 0 && newIndex == 1){
                		var groupName = $("#groupName").val();
				    	 if( (groupName).length < 1 ) {
					    	$('#groupName').css('background', 'yellow'); 
					       	setTimeout(function () {
					        $('#groupName').css('background', 'white').focus(); 
					       	}, 800);
					    	return false;
				    	}
				    	var tin = $("#USER_TINNUM").val();
	                	var pan = $("#USER_PANID").val();
	                	var gst = $("#USER_GSTNO").val();
                	
            		 	if( (tin).length < 1 ) {
							$('#USER_TINNUM').css('background', 'yellow'); 
						       	setTimeout(function () {
						           	$('#USER_TINNUM').css('background', 'white').focus(); 
						       	}, 800);
						    	return false;
					      	}
						if( (pan).length < 1 || !ValidatePAN()){
						   	$('#USER_PANID').css('background', 'yellow'); 
					     	setTimeout(function () {
					           	$('#USER_PANID').css('background', 'white').focus(); 
					       	}, 800);
					    	return false;
					    }
					 	if( (gst).length < 1 || !ValidateGST()){
					    	$('#USER_GSTNO').css('background', 'yellow'); 
					       	setTimeout(function () {
					           	$('#USER_GSTNO').css('background', 'white').focus(); 
					       	}, 800);
					    	return false;
					  	}
                		return true;
                	}
                	if(currentIndex == 1 && newIndex == 2){
                	
                	 var address1 = $("#address1").val();
	                	 var city = $("#city").val();
	                	 var email = $("#emailAddress").val();
	                	 var Altemail = $("#AltemailAddress").val();
	                	
	                	  if( (address1).length < 1 ) {
						    	$('#address1').css('background', 'yellow'); 
						       	setTimeout(function () {
						           	$('#address1').css('background', 'white').focus(); 
						       	}, 800);
						    	return false;
					      }
	                	  if( (city).length < 1 ) {
						    	$('#city').css('background', 'yellow'); 
						       	setTimeout(function () {
						           	$('#city').css('background', 'white').focus(); 
						       	}, 800);
						    	return false;
					    	}
						    if((email).length!=0&&!validateEmail(email)){
						    	alert("invalid email");
						    	$('#email').css('background', 'yellow'); 
						       	setTimeout(function () {
						           	$('#email').css('background', 'white').focus(); 
						       	}, 800);
						    	return false;
						    }
						    if((Altemail).length!=0&&!validateEmail(Altemail)){
						    	alert("Invalid Alternative Email Id");
						    	$('#Altemail').css('background', 'yellow'); 
						       	setTimeout(function () {
						           	$('#Altemail').css('background', 'white').focus(); 
						       	}, 800);
						    	return false;
						    }
                		
                	return true;
                	}
                	
                },
                onFinishing: function (event, currentIndex)
                {	
                    return true;
                },
                onFinished: function (event, currentIndex)
                {
					var form = ($(this)).parent();
                	form.submit();
                }
            });
	}); 
	
	var BankListJSON = ${StringUtil.wrapString(BankListJSON)!'[]'};
    
    var brachesGeoLIst = ${StringUtil.wrapString(brachesGeoLIst)!'[]'};
    
    var stateList = ${StringUtil.wrapString(stateDistJSONLIST)!'[]'};
	var stateWiseDistMap = ${StringUtil.wrapString(stateDistJSONMAP)!'[]'};
	
	var DistNamesJSON = ${StringUtil.wrapString(DistNamesJSON)!'[]'};
	var stateNamesJSON = ${StringUtil.wrapString(stateNamesJSON)!'[]'};
	
	 $(document).ready(function(){
    
   
    
    $("#state").autocomplete({ source: stateList }).keydown(function(e){});
    
		$("#bankName").autocomplete({					
			source:  BankListJSON,
			select: function(event, ui) {
		     var selectedValue = ui.item.value;
		       $("#bankName").val(selectedValue);	
					    }
		});
		
		
		$("#branch").autocomplete({					
			source:  brachesGeoLIst,
			select: function(event, ui) {
			  var selectedValue = ui.item.value;
				
				var branch = selectedValue;
				var bankName = $("#bankName").val();	
				
				var dataJson = {"branch": branch, "bankName":bankName};
					      
			   jQuery.ajax({
                url: 'getIfscCode',
                type: 'POST',
                data: dataJson,
                dataType: 'json',
               success: function(result){
					if(result["_ERROR_MESSAGE_"] || result["_ERROR_MESSAGE_LIST_"]){
					    alert("No Branches Available");
					}else{
						var ifscCode = result["ifscCode"];
						$("#ifscCode").val(ifscCode.ifscCode);
               		}
               	}					        
					        
		});
					      
					    }
		});
		
  });
   
	function getStateCities(selection){ 
	   value = $("#state").val();
	   var distList = stateWiseDistMap[value];
	   var statename= stateNamesJSON[value];
	   $("#distic").autocomplete({ source: distList }).keydown(function(e){});
	   $("#stateLabel").html("<h6>"+statename+"</h6>");
	} 	
	
	function showDistName(){ 
		var value = $("#distic").val();
		var distName = DistNamesJSON[value];
		$("#disticLabel").html("<h6>"+distName+"</h6>");
	}
	
	
	function ValidatePAN() {
		var nPANNo = $("#USER_PANID").val();
		var pancardPattern = /^([a-zA-Z]{5})(\d{4})([a-zA-Z]{1})$/;
		var patternCheck=pancardPattern.test(nPANNo);
		if(!patternCheck){
			$("#dispMesg").html("<h6>Invalid PAN Number..</h6>");
			$("#dispMesg").show();
			return false;
		}else{
			$("#dispMesg").hide();
		}
		return true;
	}
	
	function ValidateGST() {
		var nGSTNo = $("#USER_GSTNO").val();
		var gstPattern = /^(\d{2})([0-9a-zA-Z]{13})$/;
		var patternCheckForGst=gstPattern.test(nGSTNo);
		if(!patternCheckForGst){
			$("#dispMsg").html("<h6>Invalid GST Number..</h6>");
			$("#dispMsg").show();
			return false;
		}else{
			$("#dispMsg").hide();
		}
		return true;
	}
	
</script>
	<form id="EditPartyGroup"  action="<@ofbizUrl>createSupplier</@ofbizUrl>" name="EditPartyGroup" method="post">
	    <div id="wizard-2">
        <h3>Group Information</h3>
        <section>
        	<fieldset>
	        	<table cellpadding="2" cellspacing="1">
	            	<tr>
				    	<td class="label"><b>Group Name*</b></td>
				        <td>
        		 			<input class="h3" type="text" size="18" maxlength="100" name="groupName" id="groupName"  />
          				</td>
				    </tr>
					<tr>
			         	<td class="label"><FONT COLOR="red">*</font><b>Tin Number :</b></td>
			        	<td> 
			        		<input class="h3" type="text" size="18" maxlength="100" name="USER_TINNUM" id="USER_TINNUM" onblur="javascript:partyIdentificationVal();" />
		        		</td>
			        </tr>
					<tr>
			        	<td class="label"><FONT COLOR="red">*</font><b>Pan Number :</b></td>
			        	<td>
    		 				<input class="h3" type="text" size="18" maxlength="100" name="USER_PANID" id="USER_PANID" onblur="javascript:ValidatePAN();"/>
    		 				<FONT COLOR="red"> <div id="dispMesg"> </div> </font>
      					</td>
			        </tr>
			        <tr>
	                    <td class="label" id="ADHLABEL"><FONT COLOR="red"></font><b>Aadhar Number :</b></td>
				        <td>
	    		 			<input class="h3" type="text" size="18" maxlength="100" name="USER_ADHNUMBER" id="USER_ADHNUMBER"  />
	      				</td>
			        </tr>
			        <tr>
				        <td class="label"><FONT COLOR="red">*</font><b>Gst Number :</b></td>
				        <td>
	    		 			<input class="h3" type="text" size="18" maxlength="100" name="USER_GSTNO" id="USER_GSTNO" onblur="javascript:ValidateGST();"/>
	    		 			<FONT COLOR="red"> <div id="dispMsg"> </div> </font>
	      				</td>
			        </tr>
	            </table>
            </fieldset>  
		</section>
        <h3>Contact Information</h3>
            <section>
            	<fieldset>
				    <table cellpadding="2" cellspacing="1">
   			            <tr>
   			           		<td align='left' valign='middle' nowrap="nowrap"><div class='h2'>Contact Info</div></td>
		                </tr>
						<tr>
						    <td class="label"><FONT COLOR="red">*</font><b>Address1</b></td>
						    <td>
						      	<input type="text" name="address1" id="address1" size="30" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><b> Address2</b></td>
						    <td>
						      	<input type="text" name="address2" id="address2" size="30" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><FONT COLOR="red">*</font><b> City</b></td>
						    <td>
						      	<input type="text" name="city" id="city" size="30" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
							<td class="label">State:</td>
						 	<td><input type="text" name="state" id="state" size="30" maxlength="60"/>
						 	<div id="stateLabel">  </div>
						 	</td>
						</tr>
						<tr>
						    <td class="label"><b>Postal Code:</b></td>
						    <td>
						      	<input type="text" name="postalCode" id="postalCode" size="30" maxlength="60" value="0" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><b> E-mail Address</b></td>
						    <td>
						      	<input type="text" name="emailAddress" id="emailAddress" size="30" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><b>Alternative E-mail Address</b></td>
						    <td>
						      	<input type="text" name="AltemailAddress" id="AltemailAddress" size="30" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><b>Country Code</b></td>
						    <td>
						      	<input type="text" name="countryCode" id="countryCode" size="5" maxlength="60" autocomplete="off" />
						    </td>
						</tr>
						<tr>
						    <td class="label"><b>Mobile Number</b></td>
						    <td>
						      	<input type="text" name="mobileNumber" id="mobileNumber" size="15" maxlength="10" autocomplete="off" />
						    </td>
					    </tr>
						<tr>
						    <td class="label"><b>Contact Number</b></td>
						    <td>
						      	<input type="text" name="contactNumber" id="contactNumber" size="15" maxlength="15" autocomplete="off"/>
						    </td>
					    </tr>
						
						<tr>
						    <td>
						      	<input type="hidden" name="countryGeoId" id="countryGeoId" size="30" value="IND" autocomplete="off"/>
						    </td>
						</tr>
				        </tr>
	                 </table>
                </fieldset>  
            </section>
  
                <h3>BANK AND IDENTIFICATION DETAILS</h3>
            <section>
            	<fieldset>
				    <table cellpadding="2" cellspacing="1" class="table-style-9">
		       			           <tr>
		       			           		<td align='left' valign='middle' nowrap="nowrap"><div class='h2'>Bank Details</div></td>
					               </tr>
					               <tr>
									    <td class="label"><b> Bank :</b></td>
									    <td>
									      	<input type="text" name="bankName" id="bankName" size="30" maxlength="60"/>
									    </td>
									</tr>
					               
					               <tr>
									    <td class="label"><b>Account Branch :</b></td>
									     <td>
						                 	<input type="text" name="branch" id="branch" size="30" maxlength="60"/>
							            </td>
									</tr>
									
									<tr>
									    <td class="label"><b> Ifsc Code :</b></td>
									    <td>
									      	<input type="text" name="ifscCode" id="ifscCode" size="30" maxlength="60" value="0"  />
									    </td>
									</tr>
									
									
									<tr>
									    <td class="label"><b> Account No :</b></td>
									    <td>
									      	<input type="text" name="accNo" id="accNo" size="30" maxlength="60" autocomplete="off" />
									    </td>
									</tr>
									<tr>
									    <td class="label"><b> Account Name :</b></td>
									    <td>
									      	<input type="text" name="accName" id="accName" size="30" maxlength="60" autocomplete="off" />
									    </td>
									</tr>
									 
					        </tr>
		                 </table>
                    </fieldset>  
               </section>
               
               
                </form>
			
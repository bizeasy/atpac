<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<div class="screenlet">
  
  
  <div class="screenlet-title-bar">
    <ul>
      <li class="h3">${uiLabelMap.ProductFindOrdersToPick}</li>
    </ul>
    <br class="clear"/>
  </div>
  <div class="screenlet-body">
    
    
    
    <!-- 
    <table cellspacing="0" class="basic-table">
    	<input type="hidden" name="productStoreId" id="productStoreId" value="${globalContext.productStoreId}"/>
		<input type="hidden" name="facilityId" id="facilityId" value="${globalContext.facilityId}"/>
		
		<tr>
	        <td class="label">Order Id : </td>
	        <td ><input type="text" name="orderId" size="30" maxlength="60" required/></td>
      	</tr>
    </table>
    -->
    
    
    <form name="returnItems" method="post" action="<@ofbizUrl>createSalesReturns</@ofbizUrl>">
      <table border='0' cellpadding='2' cellspacing='0'>
        <tr>
            <td width='25%' align='right' nowrap="nowrap"><div>${uiLabelMap.OrderOrderId}</div></td>
            <td>&nbsp;</td>
            <td width='25%'>
              <input type='text' name='orderId' size='20' maxlength='20' <#if orderId?has_content>value='${orderId}'</#if>/>
            </td>
            <td><div class="tooltip">${uiLabelMap.OrderReturnLoadItems}</div></td>
          </tr>
        <tr>
          <td colspan="2">&nbsp;</td>
          <td colspan="2">
            <a href="javascript:document.returnItems.submit();" class="buttontext">${uiLabelMap.OrderReturnLoadItems}</a>
          </td>
        </tr>
      </table>
    </form>
    
    
  </div>
</div>
<#if (orderHeader?has_content)>
<div class="screenlet">
    <div class="screenlet-title-bar">
        <div class="h3">${uiLabelMap.OrderReturnItems}</div>
    </div>
    <div class="screenlet-body">
        <#-- DO NOT CHANGE THE NAME OF THIS FORM, it will break the some of the multi-service pattern features -->
        <#assign selectAllFormName = "selectAllForm"/>
        <form name="selectAllForm" method="post" action="<@ofbizUrl>createReturnHeaderAndItems</@ofbizUrl>">
          <input type="hidden" name="_checkGlobalScope" value="Y"/>
          <input type="hidden" name="_useRowSubmit" value="Y"/>
          <input type="hidden" name="fromPartyId" value="${partyId!}"/>
          <input type="hidden" name="toPartyId" value="${toPartyId!}"/>
          <input type="hidden" name="orderId" value="${orderId}"/>
          <input type="hidden" name="needsInventoryReceive" value="${parameters.needsInventoryReceive?default("Y")}"/>
          <input type="hidden" name="destinationFacilityId" value="${destinationFacilityId!}"/>
          <input type="hidden" name="returnHeaderTypeId" value="${returnHeaderTypeId}"/>
          <#if (orderHeader?has_content) && (orderHeader.currencyUom?has_content)>
          <input type="hidden" name="currencyUomId" value="${orderHeader.currencyUom}"/>
          <#include "ReturnItemInc.ftl"/>
          </#if>
          
          <hr />
          
          <#--
          
          <#if "CUSTOMER_RETURN" == returnHeaderTypeId>
          <h3>${uiLabelMap.FormFieldTitle_paymentMethodId}:</h3>
          <table cellspacing="0" class="basic-table">
            <tr><td>
              <#if creditCardList?? || eftAccountList??>
                <select name='paymentMethodId'>
                  <option value=""></option>
                  <#if creditCardList?has_content>
                    <#list creditCardList as creditCardPm>
                      <#assign creditCard = creditCardPm.getRelatedOne("CreditCard", false)>
                      <option value="${creditCard.paymentMethodId}">CC:&nbsp;${Static["org.apache.ofbiz.party.contact.ContactHelper"].formatCreditCard(creditCard)}</option>
                    </#list>
                  </#if>
                  <#if eftAccountList?has_content>
                    <#list eftAccountList as eftAccount>
                      <option value="${eftAccount.paymentMethodId}">EFT:&nbsp;${eftAccount.nameOnAccount!}, ${eftAccount.accountNumber!}</option>
                    </#list>
                  </#if>
                </select>
              <#else>
                <input type='text' size='20' name='paymentMethodId' />
              </#if>
              <#if (party.partyId)?has_content>
                <a href="/partymgr/control/editcreditcard?partyId=${party.partyId}${StringUtil.wrapString(externalKeyParam)}" target="partymgr" class="smallSubmit">${uiLabelMap.AccountingCreateCreditCard}</a>
              </#if>
            </td></tr>
          </table>
          </#if>
          <table cellspacing="0" class="basic-table">
            <tr><td colspan="8"><hr/></td></tr>
            <tr>
              <td colspan="8"><h3><#if "CUSTOMER_RETURN" == returnHeaderTypeId>${uiLabelMap.OrderReturnShipFromAddress}<#else>${uiLabelMap["checkhelper.select_shipping_destination"]}</#if></h3></td>
            </tr>
            <tr>
              <td colspan="8">
                <table cellspacing="0" class="basic-table">
                  <#list shippingContactMechList as shippingContactMech>
                    <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
                    <tr>
                      <td align="right" valign="top" nowrap="nowrap">
                      <label>
                        <input type="radio" name="originContactMechId" value="${shippingAddress.contactMechId}"  <#if (shippingContactMechList?size == 1)>checked="checked"</#if> />
                        <span>
                          <#if shippingAddress.toName?has_content><span class="label">${uiLabelMap.CommonTo}</span>&nbsp;${shippingAddress.toName}<br /></#if>
                          <#if shippingAddress.attnName?has_content><span class="label">${uiLabelMap.CommonAttn}</span></b>&nbsp;${shippingAddress.attnName}<br /></#if>
                          <#if shippingAddress.address1?has_content>${shippingAddress.address1}<br /></#if>
                          <#if shippingAddress.address2?has_content>${shippingAddress.address2}<br /></#if>
                          <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                          <#if shippingAddress.stateProvinceGeoId?has_content><br />${shippingAddress.stateProvinceGeoId}</#if>
                          <#if shippingAddress.postalCode?has_content><br />${shippingAddress.postalCode}</#if>
                          <#if shippingAddress.countryGeoId?has_content><br />${shippingAddress.countryGeoId}</#if>
                        </span>
                      </label>
                      </td>
                    </tr>
                  </#list>
                </table>
              </td>
            </tr>
          </table>
          -->
        </form>
    </div>
</div>
</#if>
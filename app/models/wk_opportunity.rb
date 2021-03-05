# ERPmine - ERP for service industry
# Copyright (C) 2011-2020  Adhi software pvt ltd
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class WkOpportunity < ActiveRecord::Base
  unloadable
  
  belongs_to :parent, :polymorphic => true
  belongs_to :assigned_user, :class_name => 'User'
  has_many :activities, as: :parent, class_name: 'WkCrmActivity', :dependent => :destroy
  validates_presence_of :name, :amount
  
  def self.opportunity_notification(oppEntry)
    opportunityHelper = Object.new.extend(WkopportunityHelper)
    salestagehash = opportunityHelper.getSaleStageHash
    emailNotes = "Opportunity : " + oppEntry.name + " status has been changed to " + salestagehash[oppEntry.sales_stage_id] + "\n\n" + l(:label_redmine_administrator)
		subject = l(:label_opportunity) + " " + l(:label_notification)
    userId = (WkPermission.permissionUser('B_CRM_PRVLG') + WkPermission.permissionUser('A_CRM_PRVLG')).uniq
    WkNotification.notification(userId, emailNotes, subject, oppEntry, 'opportunityStatusChanged')
  end
end

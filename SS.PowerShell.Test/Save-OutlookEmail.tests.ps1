﻿Describe "Save-OutlookEmail" {
	#Context "Should error if..." {
	#	It "no parameters passed" {
	#		#Remove-Module SS.PowerShell -ErrorAction Ignore
	#		#Import-Module SS.PowerShell
	#		#New-OutlookEmail -ErrorVariable err
	#		#Remove-Module SS.PowerShell
	#		#$err | Should Not BeNullOrEmpty
	#		#$err[0].Exception.Filename | Should BeLike "*NotExists.json"
	#		#$err[0].Exception.Message | Should BeLike "Schema file not found!*"
	#	}
	#	It "JSON file does not exist" {
	#		#Import-Module SS.PowerShell
	#		#Test-JsonSchema $PSScriptRoot\PersonSchema.json $PSScriptRoot\InValid.json -ErrorVariable err
	#		#Remove-Module SS.PowerShell
	#		#$err | Should Not BeNullOrEmpty
	#		#$err[0].Exception.Filename | Should BeLike "*InValid.json"
	#		#$err[0].Exception.Message | Should BeLike "Json file not found!*"
	#	}
	#	It "person age is invalid JSON schema" {
	#		#Import-Module SS.PowerShell
	#		#($result = Test-JsonSchema $PSScriptRoot\PersonSchema.json $PSScriptRoot\PersonInValidAge.json -ErrorVariable err).Valid | Should Be $false
	#		#Remove-Module SS.PowerShell
	#		#$result.Errors | Should Not BeNullOrEmpty
	#		#$result.Errors[0].Message | Should BeLike "* is less than minimum value of 0."
	#	}
	#}
	Context "Should pass if..." {
		It "save new bare email msg object as param" {
			Remove-Module SS.PowerShell -ErrorAction Ignore
			try{
				Import-Module SS.PowerShell
				$msg = New-OutlookEmail -SenderEmail "user@example.org" -Subject "Test Subject" -Draft -ErrorVariable err
				$msg | Should -Not -BeNullOrEmpty
				$msg.Sender.EmailAddress | Should -Be "user@example.org"
				$msg.Subject | Should -Be "Test Subject"
				$err | Should -BeNullOrEmpty
				Save-OutlookEmail -Email $msg -File "$PSScriptRoot\Test1.msg" -Force
			} finally {
				Remove-Module SS.PowerShell -Force
			}
		}
		It "save new email msg object with embedded image" {
			Remove-Module SS.PowerShell -ErrorAction Ignore
			try{
				Import-Module SS.PowerShell
				$msg = New-OutlookEmail -SenderEmail "user@example.org" -Subject "Test Subject" -BodyHtml "<img src=""cid:win-icon"" />" -Draft -ErrorVariable err
				$msg | Add-OutlookEmailAttachment -File "$PSScriptRoot\win-2016-icon.png" -Inline -ContentId "win-icon"
				$msg.Attachments.Count | Should -BeGreaterThan 0
				$msg.Sender.EmailAddress | Should -Be "user@example.org"
				$msg.Subject | Should -Be "Test Subject"
				$err | Should -BeNullOrEmpty
				Save-OutlookEmail -Email $msg -File "$PSScriptRoot\TestWithEmbeddedImage.msg" -Force
			} finally {
				Remove-Module SS.PowerShell -Force
			}
		}
	}
}
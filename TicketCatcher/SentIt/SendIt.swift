//
//  SendIt.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/22/24.
//

import Foundation
import SwiftSMTP
import SwiftUICore

func sendEmails(bgColor: Color, fgColor: Color, imgAssetLink: String, title: String, limit: Int, paragraph: String, updateProgress: @escaping (Int) -> Void) {
    let savedPassword = UserDefaults.standard.string(forKey: "key") ?? "NOKEY"
    
    let smtp = SMTP(
        hostname: "smtp.sendgrid.net",
        email: "apikey",
        password: savedPassword
    )
    
    let from = Mail.User(name: "Junior Prom 2024", email: "will@stuymnemonics.com")
    let recipients = [
        Mail.User(email: "will@stuymnemonics.com")
    ]
    
    let content = """
    <html>
    <head>
        <meta name="color-scheme" content="light only">
        <meta name="supported-color-schemes" content="light only">
    </head>
    <body
        style="text-align: center; font-family: 'Helvetica Neue', sans-serif; font-size: 12; color: \(fgColor.hexString()) !important; margin: 0; padding: 0; background-color: \(bgColor.hexString()) !important;">
        <div style="max-width: 500px; margin: 0 auto; padding: 50px;">
            <div style="margin-bottom: 50px;">
                <img src="\(imgAssetLink)"
                    alt="School Logo" style="max-width: 100px;">
            </div>
            <div style="font-size: larger;">
                <p>\(paragraph)</p>
            </div>
        </div>
    </body>
    </html>
    """
    
    func sendAllEmails() {
        var emailSentCount = 0
        var emailFailed = false
        
        let group = DispatchGroup()
        
        for _ in 1...limit {
            group.enter()
            let mail = Mail(
                from: from,
                to: recipients,
                subject: title,
                attachments: [
                    Attachment(
                        htmlContent: content
                    )
                ]
            )
            
            smtp.send(mail) { error in
                if let error = error {
                    print("Error sending email: \(error)")
                    emailFailed = true
                } else {
                    emailSentCount += 1
                    updateProgress(emailSentCount)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if emailFailed {
                print("Network error/congestion. Trying again in 10 minutes.")
                DispatchQueue.global().asyncAfter(deadline: .now() + 600) {
                    sendAllEmails()
                }
            } else {
                print("All emails sent successfully with \(emailSentCount) emails sent.")
            }
        }
    }
    
    DispatchQueue.global().async {
        sendAllEmails()
    }
}

extension Color {
    func hexString() -> String {
        let components = self.cgColor?.components
        let r = Float(components?[0] ?? 0)
        let g = Float(components?[1] ?? 0)
        let b = Float(components?[2] ?? 0)
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

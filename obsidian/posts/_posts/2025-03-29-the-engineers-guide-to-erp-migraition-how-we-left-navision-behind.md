---
share: true
layout: post
title: "The Engineer's Guide to ERP Migration: How We Left Dynamics NAV Behind"
date: 2025-04-05 10:21:00 -0300
filename: essay/_posts/2025-03-29-the-engineers-guide-to-erp-migraition-how-we-left-navision-behind
tags:
  - programming
  - erp
  - migration
  - navision
  - engineering
excerpt: When Ur&Penn decided to leave Microsoft Dynamics NAV after 14 years, most called us "ambitious" for building our own ERP from scratch. As the lead engineer responsible for this migration, I designed a hybrid architecture that eliminated the limitations of off-the-shelf solutions while preserving years of business-critical data. This is the untold technical story of how we successfully migrated a complex retail operation serving the Nordic region to a custom ERP system without disrupting daily operations. I'll share the architecture decisions, migration strategies, and unexpected challenges that shaped our journey away from NAV toward a solution perfectly tailored to our unique retail needs.
image: /images/pages/city-enterprise.jpg
---
## Introduction

Dynamics NAV, also known as Navision, is a robust ERP (Enterprise Resource Planning) software backed by Microsoft. **Ur&Penn** had been using Dynamics NAV for 14 years, where it became deeply ingrained in their daily operations, from Product and WMS to customer interactions via different channels like POS, E-Commerce, Self-Checkout, and more. **Ur&Penn** is one of the largest retailers in the Nordics, particularly in Sweden, exemplifying innovation and success in applying technology to solve problems and improve employee efficiency.

Building your own ERP is rarely discussed (initially, people called our plans "ambitious" 🤓) due to the complexity and risks involved. However, **Ur&Penn** boldly ventured into this territory because of the limitations inherent in large-scale commercial software. Specifically, NAV is a generic system that doesn't easily adapt to the unique needs of each business. While it's certainly impressive (there's a reason it's the most widely used ERP system globally, though its database architecture leaves much to be desired 😬), it makes workflows unnecessarily complex and difficult.

Implementing changes or adding functionality typically takes weeks or months, requiring navigation through multiple channels of resellers or authorized NAV providers. The costs are substantial, which would be acceptable if the software offered comprehensive functionality, but it doesn't. The POS system must be built or purchased separately, as must human resources modules, finance modules for EU companies, and numerous external integrations that are cumbersome to implement. Due to the high costs, developmental challenges, and endless maintenance requirements for the IT department, the decision to build a custom ERP was set in motion.

As the lead software engineer for this migration project, I was responsible for designing the architecture of our ERP solution, development, and orchestrating the complex data migration from Dynamics NAV. My role involved not only writing code but also mapping business processes, collaborating with department heads to understand their specific needs, and ensuring that historical data remained intact and accessible in the new system while implementing new features. With over 10 years of experience in enterprise software development, I approached this project by first understanding the limitations of our existing NAV implementation, then creating a migration roadmap that minimized business disruption while maximizing the benefits of our tailored solution.

Due to the transactional nature of ERPs, I couldn't adopt a pure microservice-based architecture. Instead, I implemented a monolithic structure with microservice elements, keeping the core ERP functionality clean and robust for all other modules through what I call "Pipelines". For example, a sales pipeline that applies consistent logic regardless of the sales channel, based on various parameters. We maintained separate APIs for POS (already developed by Ur&Penn's excellent team), Self-checkout, E-commerce, HR, Finance, Brand Management, Supplier Relations, Customer Service, and many other integrations.

In this blog post, I'll share my experience and the challenges we faced while successfully migrating such a complex system, which might prove useful for other technical professionals considering a similar path.

---

## Technical Architecture & Design Decisions

I selected a monolithic architecture because ERP systems are highly transactional and must maintain atomicity. With our available resources (both for development and time constraints), I couldn't justify experimenting with newer architectural patterns. The monolithic approach allowed us to build core ERP functionality for Inventory (including Purchasing), Sales, WMS, Finance, Ledgers, and other essential functions within a single core engine. Meanwhile, Ur&Penn specific requirements were developed in external APIs, keeping the core more generic and giving us flexibility for necessary integrations without compromising the system's integrity. This approach enabled us to build an MVP that we successfully launched, with plans for post-implementation improvements, a decision that proved advantageous.

My "Pipelines" concept became one of the most intelligent aspects of the ERP design. These pipelines incorporate one-time validations and logical decision points that handle complex chains of processes affecting multiple components simultaneously, determining whether steps should involve postings, orders, or other actions based on various parameters. This approach saved considerable time when integrating systems like POS with different logical scenarios but identical posting requirements, as we could reuse logic without additional development. The pipelines are sophisticated enough to selectively use transactions based on parameters, making them versatile for chained operations from other pipelines or standalone use (directly from endpoints/mutations).

I prioritized open-source software to avoid licensing complications, selecting PostgreSQL as our primary database, Redis for NoSQL requirements, and Meilisearch as our search engine (sorry, Elasticsearch). For the backend, we implemented JavaScript with NestJS as our core framework. The main API uses GraphQL for 99% of operations, significantly enhancing performance and reducing maintenance needs. We also utilize Python extensively, building supplementary APIs in Python (including ML inference APIs), PHP for POS and existing integrations, and ReactJS for the frontend.

The entire system was designed for serverless deployment from the ground up, allowing easy migration between cloud providers. I initially planned for Kubernetes deployment, but given Ur&Penn's deep integration with Google Cloud services, we leveraged Google's serverless offerings. Everything connects to version control with automatic deployment to different environments based on branch via CI/CD. Pre-publication checks ensure zero downtime, complemented by load balancing and automatic scaling.

While I acknowledge NAV's strengths in reliability and stability once configured, its flaws became most apparent during data migration. The unusual database table structure, lacking defined constraints between table key connections, offers flexibility for adding records but creates challenges for maintaining state and relationships during data insertion. The absence of foreign key constraints caused numerous issues as we encountered deleted data referenced in other tables. After 14 years of data accumulation, Ur&Penn had adapted to this approach, but we couldn't import records where foreign key connections were missing. This represents one of NAV's most significant limitations, though it may seem inconsequential to non-technical users once initially configured (despite occasionally affecting business operations).

---

## Migration Strategy & Implementation

Data migration emerged as our primary challenge, delaying our go-live date multiple times due to various complexities. We needed to ensure minimal downtime since Ur&Penn couldn't close stores during the migration process, requiring creative solutions to transition without operational interruption, which we successfully achieved.

NAV's lack of key constraints between tables necessitated building a specialized API for data migration. This API mapped all necessary fields from NAV to our ERP, verifying each field's existence before posting. This process was exceptionally time-consuming due to missing data and fundamental differences in how our ERP handles organizational structures compared to NAV, which doesn't support multi-company profiles effectively. The approach was necessary given our time constraints and NAV's SQL implementation without auto-generated keys. Since Ur&Penn operates multiple companies across the Nordic region, we developed logic to consolidate everything into a unified system with hierarchical data structures for master data, organizational entities, locations, warehouses, stores, and other dimensional data.

Testing and validation were conducted manually due to the associated risks and lack of direct comparison methods between systems. Team members, including Purchasers and Inventory Managers, inspected segments of the new system to verify data accuracy (a process that significantly improved our migration procedures, though it required multiple iterations). We performed comprehensive checks across inventory, ledgers, purchases, sales, transfers, items, and other critical areas.

Since we couldn't simply deactivate one system while activating the other, particularly with e-commerce orders flowing continuously worldwide, we developed a superior approach, albeit one requiring additional effort. We maintained both systems concurrently, establishing a cutoff date after which all integrations would transmit data to both platforms. This strategy enabled us to keep NAV operational as a contingency while validating data and identifying discrepancies in the new system through comparative analysis. This insightful decision from Ur&Penn's IT department head proved invaluable. We migrated all data preceding the cutoff date and ensured proper connections between pre- and post-cutoff information. For ongoing open orders, we conducted manual data migration cleanup over a sleepless 48-hour weekend. This manual intervention was necessary because NAV structures Sales, Transfers, and Purchases differently across multiple tables, and we determined that developing a comprehensive automated solution for relatively few open orders (with missing foreign key constraints) wasn't worth the additional development effort.

---

## Challenges & Lessons Learned

Throughout the migration, we encountered numerous challenges. While logical issues were quickly resolved, data problems repeatedly delayed our launch. I learned several valuable lessons through difficult experiences, particularly regarding the importance of thorough initial data analysis. In retrospect, implementing a direct one-time connection migration from NAV to our ERP database, rather than the continuous line-by-line posting approach I chose, would have saved considerable time and reduced complications.

Integration with external systems presented another significant challenge. We maintain numerous integrations with platforms including gift card systems, our custom-built price and promotion engine, HR systems, robotic WMS lifts, AI-powered order forecasting and creation, self-checkout solutions, POS, and many others. I initially estimated completing these integrations within 1-2 months, but they required substantially more time due to dependencies on external validation, coordination meetings, and procedural constraints. This area offers opportunities for improvement by developing more efficient migration methodologies.

Resource limitations also affected our progress. Despite initially having numerous developers available, we encountered difficulties because ERPs represent complex logical systems, and developers struggled to implement logic according to requirements. This created a dilemma: either invest 3-6 months teaching developers ERP process flows or review and revise their work afterward (which proved time-consuming and stressful). While acknowledging potential bias, I believe distributing work across more developers often generates additional meetings, reviews, and coordination overhead, potentially slowing integration, particularly for comprehensive system migrations rather than maintenance or feature development.

Today, Ur&Penn operates with unprecedented time and cost efficiency, and this represents just the beginning since the ERP forms the core and intelligence driving the business forward. Our platforms are intuitive and straightforward, even in MVP form, with plans to implement additional features and functionality that enable employees to focus on objectives rather than processes.

The platform is sophisticated yet architected to facilitate easy feature additions and extensions, both from development and user perspectives. This design reflects 14 years of Ur&Penn's operational experience and my decade of translating business requirements into functional code.

## Conclusion

The journey of migrating from Dynamics NAV to our custom ERP solution has been challenging but immensely rewarding. What started as an "ambitious" plan has transformed into a tailored system that truly fits Ur&Penn's unique retail operations across the Nordics. By embracing the challenge of building our own solution, we've eliminated the limitations, high costs, and endless maintenance cycles that came with our 14-year NAV implementation.

The custom ERP we've built provides Ur&Penn with complete control over their technology stack, faster implementation of new features, and significantly reduced operational costs. Our hybrid architecture approach with a monolithic core and specialized external APIs has proven to be the right choice for balancing transactional integrity with business flexibility.

For those considering a similar path, I'd emphasize that building a custom ERP isn't for everyone. It requires deep technical expertise, business domain knowledge, and leadership support. But for organizations with unique processes and a commitment to long-term technological independence, it can be transformative.

Looking ahead, we're continuing to refine our system, adding new capabilities and optimizations that simply wouldn't have been possible or would have been prohibitively expensive with our previous setup. What we've created isn't just a replacement for NAV. It's a foundation for Ur&Penn's future innovation and growth.

If you're considering a similar migration or have questions about our approach, I'd be happy to connect and share more detailed insights from our experience.
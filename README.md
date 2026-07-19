# 🎓 Academic Data System (ADS) Relational Framework

[![Database](https://img.shields.io/badge/Database-PostgreSQL%2015%2B-blue.svg)](https://www.postgresql.org/)
[![Data-Analytics](https://img.shields.io/badge/Role-Data%20Analytics-orange.svg)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)]()

A robust, enterprise-grade relational database architecture designed to manage operations for a modern university or school system. This project transitions a highly normalized **Transactional Ledger (OLTP)** handling identities, academic scheduling, and financial accounting into an **Analytical Reporting Core (OLAP)** primed for upstream Business Intelligence (BI) modeling and Python data pipelines.

---

## 💡 Key Architectural Solutions

*   **Identity Sub-Typing (1:1 Poly-Inheritance):** Solves the single-identity problem by separating core user credentials (`users`) from specialized role traits (`students`, `teachers`, `parents`), completely removing table data duplication.
*   **Circular Constraint Mitigation:** Resolves complex database generation loops by restructuring linear downward relationship logic, ensuring smooth transactional inserts without API round-trip deadlocks.
*   **High-Scale Indexing Strategy:** Implements targeted secondary B-Tree indexing on all high-frequency operational Foreign Keys to mitigate storage fragmentation risks naturally introduced by randomized `UUID` tracking.
*   **The Analytical Flattened Layer:** Deploys a comprehensive aggregation database view that automatically handles raw operational joins to deliver live calculations for attendance weights, standardized grades, and outstanding monetary balances.

---

## 📂 Project Repository Structure

The workspace is organized into modular segments according to production best practices:

```text
final-project/
├── database/
│   ├── schema.sql          # DDL Setup: Table generation, Constraints & UUID Indexes
│   ├── insert-data.sql     # DML Setup: 20-row mutually correlated mock seed data
│   ├── queries.sql         # Operational reporting & automated anomaly detectors
│   └── views.sql           # Master Analytical transformation dashboard matrix
├── diagram/
│   ├── flowchart.png       # Lifecycle logic flow of the database pipeline
│   └── erd.png             # The 16-table visual Entity Relationship Diagram
├── documentation/
│   └── report.pdf          # Full-length technical project engineering report
└── presentation/
    └── slides.pptx         # Architectural walkthrough presentation deck

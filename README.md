# 🎯 UVM-Based Verification of Router 1x3  

This repository contains the **UVM-based verification environment** developed for a **1x3 Router design**.  
The router is responsible for directing data packets from a **single input port** to one of **three output ports** based on the destination address embedded within the packet.  

The verification focuses on ensuring **accurate packet routing**, **error detection**, **soft reset functionality**, and **robust data integrity** across various traffic scenarios.  

---

### 🔍 What’s Verified  

✅ **Router Functionality**  
- Correct routing of data packets from 1 input to 3 output ports based on destination address  
- Error flag generation for **corrupted packets** or parity mismatches  
- Automatic **soft reset trigger** when output data remains unread for 30 clock cycles  
- Verified reliable packet transfer for **small, medium, and large payloads**  
- Checked for proper synchronization and no data loss across all ports  

---

### 🔹 Verification Methodology  
- Developed a **modular UVM testbench** architecture with:  
  - Source and Destination Drivers  
  - Monitors and Sequencers  
  - Scoreboards and Functional Coverage components  
- Verified across different packet sizes and multiple transmission scenarios  
- Performed **directed and constrained-random verification**  
- Generated **area and timing reports** to analyze router efficiency  
- Achieved **100% functional coverage**, validating completeness and correctness of all key scenarios  

---

### 🧠 Skills Applied  
- UVM-based Constrained Random Verification  
- Protocol-level and Packet-based SoC Verification  
- Functional Coverage and Performance Validation  
- Debug and Analysis using Verdi and SpyGlass  

---

### 🛠️ Tools Used  
- **Synopsys VCS** – Simulation and Compilation  
- **QuestaSim** – Waveform Analysis  
- **Verdi** – Debug and Signal Tracing  
- **SpyGlass** – Linting and Static Checks  
- **Design Compiler** – Synthesis and Timing Reports  

---

### 💡 Learning Outcome  
This project strengthened understanding of **packet-based router verification**, emphasizing:  
- Data routing accuracy  
- Throughput and latency analysis  
- Coverage-driven verification closure  
- Reusable and modular UVM environment design  

---

📍 **Author:** Muttu B Naik  
📧 **Email:** [muttunaik5096@gmail.com](mailto:muttunaik5096@gmail.com)  
🔗 **LinkedIn:** https://www.linkedin.com/in/muttunaik5096 

---

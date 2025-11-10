# 3x3 Systolic Array for Vector Outer Product

This Verilog project implements a 3x3 systolic array designed to compute the **outer product** of two 3-element vectors. Each element in the vectors is a 2-bit unsigned number.

The array calculates a 3x3 matrix `C`, where each element `C[i][j]` is the result of `A[i] * B[j]`.

* **Vector A**: `[a1, a2, a3]` (Inputs `a1[1:0]`, `a2[1:0]`, `a3[1:0]`)
* **Vector B**: `[b1, b2, b3]` (Inputs `b1[1:0]`, `b2[1:0]`, `b3[1:0]`)

**Computed Matrix (Internal):**
$$
C = \begin{bmatrix}
    a1 \cdot b1 & a1 \cdot b2 & a1 \cdot b3 \\
    a2 \cdot b1 & a2 \cdot b2 & a2 \cdot b3 \\
    a3 \cdot b1 & a3 \cdot b2 & a3 \cdot b3
\end{bmatrix}
$$

The 9 resulting products (each 5 bits wide to prevent overflow during accumulation) are then streamed out, one by one, on the `out_data` port.

---

## 🏛️ Architecture

The design consists of three main Verilog modules: `top`, `pe`, and `dff`.

### 1. `dff` Module (2-bit Flip-Flop)
This is a simple 2-bit D-type flip-flop. It's used as a register to pipeline the `a` and `b` data as it moves systolically through the array, ensuring the correct data elements meet at the right PE at the right time.

* **Note**: The reset logic `always@(posedge clk, negedge reset)` is an active-low reset.

### 2. `pe` Module (Processing Element)
This is the core computational unit of the array. It is a **2-bit Multiply-Accumulate (MAC)** unit.

* **Inputs**: `in_a[1:0]`, `in_b[1:0]`
* **Output**: `out_c[4:0]`
* **Logic**: `out_c <= out_c + (in_a * in_b)`

On each positive clock edge, the `pe` multiplies its two 2-bit inputs (`in_a` and `in_b`) and adds the 4-bit result to its own internal 5-bit register `out_c`. The `reset` signal is the only event that clears this accumulator register to `0`.

### 3. `top` Module (Systolic Array)
This module instantiates a 3x3 grid of the `pe` units and the `dff` registers to connect them. It manages the data flow and the output state machine.

#### Data Flow
The `top` module skews the inputs using `dff` instances before they enter the grid, and uses other `dff` instances to pass data between PEs.

* **Vector A (`a1`, `a2`, `a3`)**: Fed into the **left-most column** of PEs. The values are then registered and passed **down** the grid (e.g., from `pe1` to `pe4` to `pe7`).
* **Vector B (`b1`, `b2`, `b3`)**: Fed into the **top row** of PEs. The values are then registered and passed **right** across the grid (e.g., from `pe1` to `pe2` to `pe3`).

This systolic flow ensures that each PE computes one element of the final outer product matrix. For example, the center `pe5` will eventually receive `a2` and `b2`, computing `a2 * b2`.

#### Output FSM (Finite State Machine)
A 3-state state machine controls the output:

1.  **`idle`**: Waits for the start of a new operation.
2.  **`load`**: In a single clock cycle, it latches the 9 `out_c` values from all 9 PEs into an internal `buffer`.
3.  **`dat_out`**: It uses an `index` counter to stream the contents of `buffer[0]` through `buffer[8]` to the `out_data` port. It outputs one 5-bit value per clock cycle.
4.  After streaming all 9 values, it returns to the `idle` state.

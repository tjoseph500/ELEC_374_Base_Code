`timescale 1ns/10ps

module datapath_tb;
    // --- Signal Declarations ---
    reg         PCout, Zlowout, MDRout, R5out, R6out;
    reg         MARin, Zin, PCin, MDRin, IRin, Yin;
    reg         IncPC, Read, SHR, R2in, R5in, R6in;
    reg         Clock;
    reg [31:0]  Mdatain;

    // Extra register signals (referenced in Default state but missing in declaration)
    reg         R3out, R7out;

    // --- State Parameters ---
    parameter Default     = 4'b0000,
              Reg_load1a  = 4'b0001, Reg_load1b = 4'b0010,
              Reg_load2a  = 4'b0011, Reg_load2b = 4'b0100,
              Reg_load3a  = 4'b0101, Reg_load3b = 4'b0110,
              T0          = 4'b0111, T1         = 4'b1000,
              T2          = 4'b1001, T3         = 4'b1010,
              T4          = 4'b1011, T5         = 4'b1100;

    reg [3:0] Present_state = Default;

    // --- Device Under Test (DUT) ---
    Datapath DUT (
        PCout, Zlowout, MDRout, R5out, R6out,
        MARin, Zin, PCin, MDRin, IRin, Yin,
        IncPC, Read, SHR, R2in, R5in, R6in,
        Clock, Mdatain
    );

    // --- Clock Generation ---
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    // --- State Transitions (Sequential Logic) ---
    always @(posedge Clock) begin
        case (Present_state)
            Default:    Present_state <= Reg_load1a;
            Reg_load1a: Present_state <= Reg_load1b;
            Reg_load1b: Present_state <= Reg_load2a;
            Reg_load2a: Present_state <= Reg_load2b;
            Reg_load2b: Present_state <= Reg_load3a;
            Reg_load3a: Present_state <= Reg_load3b;
            Reg_load3b: Present_state <= T0;
            T0:         Present_state <= T1;
            T1:         Present_state <= T2;
            T2:         Present_state <= T3;
            T3:         Present_state <= T4;
            T4:         Present_state <= T5;
            T5:         Present_state <= Default;
            default:    Present_state <= Default;
        endcase
    end

    // --- Output Logic (Combinational/State Actions) ---
    always @(Present_state) begin
        case (Present_state)
            Default: begin
                PCout <= 0;   Zlowout <= 0;   MDRout <= 0;
                R3out <= 0;   R7out <= 0;     MARin <= 0;   Zin <= 0;
                PCin <= 0;    MDRin <= 0;     IRin <= 0;    Yin <= 0;
                IncPC <= 0;   Read <= 0;      SHR <= 0;
                R2in <= 0;    R5in <= 0;      R6in <= 0;
                Mdatain <= 32'h00000000;
            end

            Reg_load1a: begin
                // Value to be shifted (R5)
                Mdatain <= 32'h00000034;
                Read <= 1; MDRin <= 1;
            end

            Reg_load1b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R5in <= 1;
            end

            Reg_load2a: begin
                MDRout <= 0; R5in <= 0;
                // Shift amount (R6) – for SHR, typical is use lower 5 bits as shift count
                Mdatain <= 32'h00000002;   // shift right by 2 (example)
                Read <= 1; MDRin <= 1;
            end

            Reg_load2b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R6in <= 1;
            end

            Reg_load3a: begin
                MDRout <= 0; R6in <= 0;
                // Initialize R2 to something (optional)
                Mdatain <= 32'h00000000;
                Read <= 1; MDRin <= 1;
            end

            Reg_load3b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R2in <= 1;
            end

            // --- Instruction fetch (same as AND TB style) ---
            T0: begin
                MDRout <= 0; R2in <= 0;
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            end

            T1: begin
                PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;

                // Opcode for “shr R2, R5, R6” (placeholder — replace with correct pattern)
                Mdatain <= 32'h00000000;
            end

            T2: begin
                Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1;
            end

            // --- Execute SHR ---
            // T3 R5out, Yin
            T3: begin
                MDRout <= 0; IRin <= 0;
                R5out <= 1; Yin <= 1;
            end

            // T4 R6out, SHR, Zin
            T4: begin
                R5out <= 0; Yin <= 0;
                R6out <= 1; SHR <= 1; Zin <= 1;
            end

            // T5 Zlowout, R2in
            T5: begin
                R6out <= 0; SHR <= 0; Zin <= 0;
                Zlowout <= 1; R2in <= 1;
            end
        endcase
    end
endmodule

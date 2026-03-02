`timescale 1ns/10ps

module datapath_tb;
    // --- Signal Declarations ---
    reg         PCout, Zlowout, Zhighout, MDRout, R3out, R1out;
    reg         MARin, Zin, PCin, MDRin, IRin, Yin;
    reg         IncPC, Read, MUL, HIin, LOin, R3in, R1in;
    reg         Clock;
    reg [31:0]  Mdatain;

    // Extra register signals (referenced in Default state but missing in declaration)
    reg         R7out;

    // --- State Parameters ---
    parameter Default     = 4'b0000,
              Reg_load1a  = 4'b0001, Reg_load1b = 4'b0010,   // load R3
              Reg_load2a  = 4'b0011, Reg_load2b = 4'b0100,   // load R1
              T0          = 4'b0101, T1         = 4'b0110,
              T2          = 4'b0111, T3         = 4'b1000,
              T4          = 4'b1001, T5         = 4'b1010,
              T6          = 4'b1011;

    reg [3:0] Present_state = Default;

    // --- Device Under Test (DUT) ---
    Datapath DUT (
        // Fetch / bus / mem style signals (same style as your AND TB, just expanded)
        PCout, Zlowout, MDRout, R3out, R1out,
        MARin, Zin, PCin, MDRin, IRin, Yin,
        IncPC, Read, MUL, LOin, HIin,
        Clock, Mdatain,

        // Extra signals (if your Datapath module has them in this order, keep; otherwise ignore/remove)
        Zhighout
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
            Reg_load2b: Present_state <= T0;
            T0:         Present_state <= T1;
            T1:         Present_state <= T2;
            T2:         Present_state <= T3;
            T3:         Present_state <= T4;
            T4:         Present_state <= T5;
            T5:         Present_state <= T6;
            T6:         Present_state <= Default; // Loop back
            default:    Present_state <= Default;
        endcase
    end

    // --- Output Logic (Combinational/State Actions) ---
    always @(Present_state) begin
        case (Present_state)
            Default: begin
                PCout <= 0;   Zlowout <= 0;  Zhighout <= 0; MDRout <= 0;
                R3out <= 0;   R1out <= 0;    R7out <= 0;
                MARin <= 0;   Zin <= 0;      PCin <= 0;     MDRin <= 0;
                IRin  <= 0;   Yin <= 0;
                IncPC <= 0;   Read <= 0;     MUL <= 0;
                LOin  <= 0;   HIin <= 0;
                R3in  <= 0;   R1in <= 0;
                Mdatain <= 32'h00000000;
            end

            // --- Load R3 with a value ---
            Reg_load1a: begin
                Mdatain <= 32'h00000034;   // value -> MDR
                Read <= 1; MDRin <= 1;
            end

            Reg_load1b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R3in <= 1;    // MDR -> R3
            end

            // --- Load R1 with a value ---
            Reg_load2a: begin
                MDRout <= 0; R3in <= 0;
                Mdatain <= 32'h00000045;   // value -> MDR
                Read <= 1; MDRin <= 1;
            end

            Reg_load2b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R1in <= 1;    // MDR -> R1
            end

            // --- MUL instruction control sequence (per Phase 1 doc) ---
            // T0 PCout, MARin, IncPC, Zin
            T0: begin
                MDRout <= 0; R1in <= 0;
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            end

            // T1 Zlowout, PCin, Read, Mdatain[31..0], MDRin
            T1: begin
                PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;

                // IMPORTANT: set this to the correct 32-bit opcode pattern for "mul R3, R1"
                // (You’ll get it from the Mini SRC / CPU spec.)
                Mdatain <= 32'h00000000;  // <-- replace with mul opcode
            end

            // T2 MDRout, IRin
            T2: begin
                Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1;
            end

            // T3 R3out, Yin
            T3: begin
                MDRout <= 0; IRin <= 0;
                R3out <= 1; Yin <= 1;
            end

            // T4 R1out, MUL, Zin
            T4: begin
                R3out <= 0; Yin <= 0;
                R1out <= 1; MUL <= 1; Zin <= 1;
            end

            // T5 Zlowout, LOin
            T5: begin
                R1out <= 0; MUL <= 0; Zin <= 0;
                Zlowout <= 1; LOin <= 1;
            end

            // T6 Zhighout, HIin
            T6: begin
                Zlowout <= 0; LOin <= 0;
                Zhighout <= 1; HIin <= 1;
            end
        endcase
    end
endmodule

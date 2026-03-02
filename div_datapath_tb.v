`timescale 1ns/10ps

module datapath_tb;
    // --- Signal Declarations ---
    reg         PCout, Zlowout, Zhighout, MDRout, R3out, R1out;
    reg         MARin, Zin, PCin, MDRin, IRin, Yin;
    reg         IncPC, Read, DIV, HIin, LOin, R3in, R1in;
    reg         Clock;
    reg [31:0]  Mdatain;

    // Extra register signals (referenced in Default state but missing in declaration)
    reg         R7out;

    // --- State Parameters ---
    parameter Default     = 4'b0000,
              Reg_load1a  = 4'b0001, Reg_load1b = 4'b0010,   // load R3 (dividend)
              Reg_load2a  = 4'b0011, Reg_load2b = 4'b0100,   // load R1 (divisor)
              T0          = 4'b0101, T1         = 4'b0110,
              T2          = 4'b0111, T3         = 4'b1000,
              T4          = 4'b1001, T5         = 4'b1010,
              T6          = 4'b1011;

    reg [3:0] Present_state = Default;

    // --- Device Under Test (DUT) ---
    Datapath DUT (
        // Keep the same "style" of positional hookup you used before.
        PCout, Zlowout, MDRout, R3out, R1out,
        MARin, Zin, PCin, MDRin, IRin, Yin,
        IncPC, Read, DIV, LOin, HIin,
        Clock, Mdatain,

        // Extra (if your Datapath has it like this, keep; otherwise remove)
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
                IncPC <= 0;   Read <= 0;     DIV <= 0;
                LOin  <= 0;   HIin <= 0;
                R3in  <= 0;   R1in <= 0;
                Mdatain <= 32'h00000000;
            end

            // --- Load R3 with dividend ---
            Reg_load1a: begin
                Mdatain <= 32'h00000034;   // dividend -> MDR
                Read <= 1; MDRin <= 1;
            end

            Reg_load1b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R3in <= 1;    // MDR -> R3
            end

            // --- Load R1 with divisor ---
            Reg_load2a: begin
                MDRout <= 0; R3in <= 0;
                Mdatain <= 32'h00000005;   // divisor -> MDR (pick something non-zero)
                Read <= 1; MDRin <= 1;
            end

            Reg_load2b: begin
                Read <= 0; MDRin <= 0;
                MDRout <= 1; R1in <= 1;    // MDR -> R1
            end

            // --- DIV instruction control sequence (same pattern as MUL in Phase 1) ---
            // T0 PCout, MARin, IncPC, Zin
            T0: begin
                MDRout <= 0; R1in <= 0;
                PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
            end

            // T1 Zlowout, PCin, Read, Mdatain[31..0], MDRin
            T1: begin
                PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;

                // IMPORTANT: set this to the correct 32-bit opcode pattern for your DIV instruction
                // (from the Mini SRC / CPU spec.)
                Mdatain <= 32'h00000000;  // <-- replace with div opcode
            end

            // T2 MDRout, IRin
            T2: begin
                Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
                MDRout <= 1; IRin <= 1;
            end

            // T3 R3out, Yin   (dividend into Y)
            T3: begin
                MDRout <= 0; IRin <= 0;
                R3out <= 1; Yin <= 1;
            end

            // T4 R1out, DIV, Zin  (divisor on bus, start DIV, store into Z)
            T4: begin
                R3out <= 0; Yin <= 0;
                R1out <= 1; DIV <= 1; Zin <= 1;
            end

            // T5 Zlowout, LOin  (quotient -> LO)
            T5: begin
                R1out <= 0; DIV <= 0; Zin <= 0;
                Zlowout <= 1; LOin <= 1;
            end

            // T6 Zhighout, HIin (remainder -> HI)
            T6: begin
                Zlowout <= 0; LOin <= 0;
                Zhighout <= 1; HIin <= 1;
            end
        endcase
    end
endmodule

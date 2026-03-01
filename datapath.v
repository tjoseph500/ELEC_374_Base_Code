module datapath(
    input wire clock, clear,

    // ===== NEW: Phase-1 Fetch Support =====
    input wire MARin, IRin, IncPC, Read,
    input wire [31:0] Mdatain,

    // ===== Bus source selects =====
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
               HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout,

    // ===== Register write enables =====
    input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
               HIin, LOin, Zin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, Yin,

    // ===== ALU op selects =====
    input wire ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, AND, OR, NEG, NOT
);

    // =========================
    // Internal wires
    // =========================
    wire [31:0] BusMuxOut;

    wire [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7,
                BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15;

    wire [31:0] BusMuxIn_HI, BusMuxIn_LO;
    wire [31:0] BusMuxIn_Zhigh, BusMuxIn_Zlow;
    wire [31:0] BusMuxIn_PC;
    wire [31:0] BusMuxIn_MDR;
    wire [31:0] BusMuxIn_InPort;
    wire [31:0] C_sign_extended;

    // NEW internal-only register outputs (not used on bus in Phase 1)
    wire [31:0] BusMuxIn_MAR, BusMuxIn_IR;

    // MDR input mux output
    wire [31:0] MDR_d;

    wire [31:0] ALUin;
    wire [63:0] ALUout;

    // =========================
    // Registers (GPRs)
    // =========================
    register R0 (clear, clock, R0in,  BusMuxOut, BusMuxIn_R0);
    register R1 (clear, clock, R1in,  BusMuxOut, BusMuxIn_R1);
    register R2 (clear, clock, R2in,  BusMuxOut, BusMuxIn_R2);
    register R3 (clear, clock, R3in,  BusMuxOut, BusMuxIn_R3);
    register R4 (clear, clock, R4in,  BusMuxOut, BusMuxIn_R4);
    register R5 (clear, clock, R5in,  BusMuxOut, BusMuxIn_R5);
    register R6 (clear, clock, R6in,  BusMuxOut, BusMuxIn_R6);
    register R7 (clear, clock, R7in,  BusMuxOut, BusMuxIn_R7);
    register R8 (clear, clock, R8in,  BusMuxOut, BusMuxIn_R8);
    register R9 (clear, clock, R9in,  BusMuxOut, BusMuxIn_R9);
    register R10(clear, clock, R10in, BusMuxOut, BusMuxIn_R10);
    register R11(clear, clock, R11in, BusMuxOut, BusMuxIn_R11);
    register R12(clear, clock, R12in, BusMuxOut, BusMuxIn_R12);
    register R13(clear, clock, R13in, BusMuxOut, BusMuxIn_R13);
    register R14(clear, clock, R14in, BusMuxOut, BusMuxIn_R14);
    register R15(clear, clock, R15in, BusMuxOut, BusMuxIn_R15);

    // Y register
    register Y(clear, clock, Yin, BusMuxOut, ALUin);

    // =========================
    // ALU (with IncPC)
    // =========================
    ALU alu(
        clear, clock,
        IncPC,
        ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, AND, OR, NEG, NOT,
        ALUin,
        BusMuxOut,
        ALUout
    );

    // Z register (64-bit)
    register64 Z(clear, clock, Zin, Zhighin, Zlowin, ALUout, BusMuxOut);

    // Special registers
    register HI(clear, clock, HIin, BusMuxOut, BusMuxIn_HI);
    register LO(clear, clock, LOin, BusMuxOut, BusMuxIn_LO);
    register PC(clear, clock, PCin, BusMuxOut, BusMuxIn_PC);

    // =========================
    // NEW: Fetch registers
    // =========================
    register MAR(clear, clock, MARin, BusMuxOut, BusMuxIn_MAR);
    register IR (clear, clock, IRin,  BusMuxOut, BusMuxIn_IR);

    // MDR loads from memory when Read=1 else from bus
    assign MDR_d = (Read) ? Mdatain : BusMuxOut;
    register MDR(clear, clock, MDRin, MDR_d, BusMuxIn_MDR);

    // =========================
    // Bus
    // =========================
    Bus bus(
        // data inputs
        BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3, BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7,
        BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11, BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15,
        BusMuxIn_HI, BusMuxIn_LO,
        BusMuxIn_Zhigh, BusMuxIn_Zlow,
        BusMuxIn_PC,
        BusMuxIn_MDR,
        BusMuxIn_InPort,
        C_sign_extended,

        // select lines
        R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out,
        R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
        HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout,

        // bus output
        BusMuxOut
    );

endmodule
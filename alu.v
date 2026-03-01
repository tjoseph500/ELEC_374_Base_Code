module ALU(
    input wire clear, clock,

    // NEW: used in Phase-1 fetch (T0: PCout, MARin, IncPC, Zin)
    input wire IncPC,

    input wire ADD, SUB, MUL, DIV, SHR, SHRA, SHL, ROR, ROL, AND, OR, NEG, NOT,

    input wire [31:0] ALUin,
    input wire [31:0] BusMuxOut,

    output reg [63:0] ALUout
);

    // =========================
    // Internal wires
    // =========================
    wire [31:0] add_out, sub_out;
    wire [63:0] mul_out;

    // divider output (keeping it 32-bit quotient for now; packed into low 32)
    wire [31:0] div_out;

    wire [31:0] shr_out, shra_out, shl_out;
    wire [31:0] ror_out, rol_out;

    wire [31:0] and_out, or_out;
    wire [31:0] neg_out, not_out;

    // =========================
    // Module Instantiations
    // =========================
    adder            add     (ALUin, BusMuxOut, add_out);
    subtract         sub     (ALUin, BusMuxOut, sub_out);
    booth_multiplier mul     (ALUin, BusMuxOut, mul_out);
    divider          div     (ALUin, BusMuxOut, div_out);

    shiftRight       shr     (ALUin, BusMuxOut, shr_out);
    shiftRightA      shra    (ALUin, BusMuxOut, shra_out);
    shiftLeft        shl     (ALUin, BusMuxOut, shl_out);

    rotate_right     ror     (ALUin, BusMuxOut, ror_out);
    rotate_left      rol     (ALUin, BusMuxOut, rol_out);

    AND              and_OP  (ALUin, BusMuxOut, and_out);
    OR               or_OP   (ALUin, BusMuxOut, or_out);

    twoCom           neg     (ALUin, neg_out);
    oneCom           not_OP  (ALUin, not_out);

    // =========================
    // Output Selection (clocked)
    // =========================
    always @(posedge clock) begin
        if (clear) begin
            ALUout <= 64'd0;
        end
        // IncPC has priority when asserted (used during fetch)
        else if (IncPC) begin
            ALUout <= {32'd0, (BusMuxOut + 32'd1)};
        end
        else if (ADD) begin
            ALUout <= {32'd0, add_out};
        end
        else if (SUB) begin
            ALUout <= {32'd0, sub_out};
        end
        else if (MUL) begin
            ALUout <= mul_out;
        end
        else if (DIV) begin
            ALUout <= {32'd0, div_out};   // quotient in low 32 bits
        end
        else if (SHR) begin
            ALUout <= {32'd0, shr_out};
        end
        else if (SHRA) begin
            ALUout <= {32'd0, shra_out};
        end
        else if (SHL) begin
            ALUout <= {32'd0, shl_out};
        end
        else if (ROR) begin
            ALUout <= {32'd0, ror_out};
        end
        else if (ROL) begin
            ALUout <= {32'd0, rol_out};
        end
        else if (AND) begin
            ALUout <= {32'd0, and_out};
        end
        else if (OR) begin
            ALUout <= {32'd0, or_out};
        end
        else if (NEG) begin
            ALUout <= {32'd0, neg_out};
        end
        else if (NOT) begin
            ALUout <= {32'd0, not_out};
        end
        else begin
            ALUout <= 64'd0;
        end
    end

endmodule
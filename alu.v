module ALU(
    input wire clear, clock,

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
wire [31:0] div_out;

wire [31:0] shr_out, shra_out, shl_out;
wire [31:0] ror_out, rol_out;

wire [31:0] and_out, or_out;
wire [31:0] neg_out, not_out;


// =========================
// Module Instantiations
// =========================

adder add  (ALUin, BusMuxOut, add_out);
subtract  sub  (ALUin, BusMuxOut, sub_out);
booth_multiplier mul  (ALUin, BusMuxOut, mul_out);
divider div (ALUin, BusMuxOut, div_out);

shiftRight shr  (ALUin, BusMuxOut, shr_out);
//shiftRightA shra (ALUin, BusMuxOut, shra_out);
shiftLeft shl  (ALUin, BusMuxOut, shl_out);

rotate_right ror  (ALUin, BusMuxOut, ror_out);
rotate_left rol  (ALUin, BusMuxOut, rol_out);

AND_Operation and_OP (ALUin, BusMuxOut, and_out);
OR_Operation or_OP (ALUin, BusMuxOut, or_out);

twoCom neg  (ALUin, neg_out);
oneCom not_OP  (ALUin, not_out);


// =========================
// Output Selection
// =========================

always @(posedge clock) begin
    if (clear)
        ALUout = 64'd0;

    else if (ADD)
        ALUout = {32'd0, add_out};

    else if (SUB)
        ALUout = {32'd0, sub_out};

    else if (MUL)
        ALUout = mul_out;

    else if (DIV)
        ALUout = div_out;

    else if (SHR)
        ALUout = {32'd0, shr_out};

    else if (SHRA)
        ALUout = {32'd0, shra_out};

    else if (SHL)
        ALUout = {32'd0, shl_out};

    else if (ROR)
        ALUout = {32'd0, ror_out};

    else if (ROL)
        ALUout = {32'd0, rol_out};

    else if (AND)
        ALUout = {32'd0, and_out};

    else if (OR)
        ALUout = {32'd0, or_out};

    else if (NEG)
        ALUout = {32'd0, neg_out};

    else if (NOT)
        ALUout = {32'd0, not_out};

    else
        ALUout = 64'd0;
end

endmodule
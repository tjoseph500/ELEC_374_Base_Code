// Subtract (32-bit): Result_sub = A_sub - B_sub
module subtract(
    input  [31:0] A_sub,
    input  [31:0] B_sub,
    output [31:0] Result_sub
);

    wire [31:0] B_twos;

    // B_twos = two's complement of B_sub
    twoCom u_twocom (
        .A_twoCom(B_sub),
        .Result_twoCom(B_twos)
    );

    // Result = A_sub + B_twos
    adder u_adder (
        .A(A_sub),
        .B(B_twos),
        .Result(Result_sub)
    );

endmodule
//TwoCom
module twoCom(
    input  [31:0] A_twoCom,
    output [31:0] Result_twoCom
);

    // internal wires
    wire [31:0] Result_oneCom;
    wire [31:0] const_1;
    wire [31:0] Result_add;

    assign const_1 = 32'h00000001;

    // 1's complement
    oneCom OneCom_inst
    (
        .A_oneCom(A_twoCom),
        .Result_oneCom(Result_oneCom)
    );

    // add 1 to get 2's complement
    adder adder_inst
    (
        .A(Result_oneCom),
        .B(const_1),
        .Result(Result_add)
    );

    assign Result_twoCom = Result_add;

endmodule
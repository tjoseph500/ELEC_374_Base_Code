module divider(
    input  [31:0] M,      // Divisor
    input  [31:0] Q,      // Dividend
    output reg [63:0] Result  // {Remainder, Quotient}
);

reg signed [32:0] A;
reg [31:0] Q_reg;

integer i;

always @(*) begin
    A     = 33'd0;
    Q_reg = Q;

    for (i = 0; i < 32; i = i + 1) begin
        
        // Shift left combined {A, Q}
        A     = {A[31:0], Q_reg[31]};
        Q_reg = Q_reg << 1;

        // Subtract divisor
        A = A - {1'b0, M};

        if (A < 0) begin
            Q_reg[0] = 1'b0;
            A = A + {1'b0, M};   // Restore
        end
        else begin
            Q_reg[0] = 1'b1;
        end
    end

    // Remainder must be 32 bits
    Result = {A[31:0], Q_reg};

end

endmodule
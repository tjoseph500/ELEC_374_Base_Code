module divider(
    input  [31:0] M,          // Divisor
    input  [31:0] Q,          // Dividend
    output reg [63:0] Result  // {Remainder, Quotient}
);

    reg signed [32:0] A;      // signed so we can test A < 0
    reg [31:0] Q_temp;        // working quotient/dividend
    integer i;

    always @(M or Q) begin
        // Optional: handle divide-by-zero deterministically
        if (M == 32'd0) begin
            // remainder = dividend, quotient = all 1s (common choice)
            Result = {Q, 32'hFFFFFFFF};
        end else begin
            A      = 33'd0;
            Q_temp = Q;

            for (i = 0; i < 32; i = i + 1) begin
                // Shift left the combined (A, Q_temp)
                A      = (A <<< 1) | Q_temp[31];
                Q_temp = (Q_temp << 1);

                // Subtract divisor
                A = A - $signed({1'b0, M});

                if (A < 0) begin
                    Q_temp[0] = 1'b0;
                    A = A + $signed({1'b0, M});  // restore
                end else begin
                    Q_temp[0] = 1'b1;
                end
            end

            // Pack remainder and quotient (32 + 32 = 64)
            Result = {A[31:0], Q_temp};
        end
    end

endmodule
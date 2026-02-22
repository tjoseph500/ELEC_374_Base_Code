module booth_multiplier (
    input  wire signed [31:0] M,
    input  wire signed [31:0] Q,
    output reg  signed [31:0] Result
);

    integer i;
    wire signed [31:0] M_Neg;
    reg  signed [63:0] partial;
    wire [32:0] Q_ext;

    // Q with extra LSB bit for Booth encoding
    assign Q_ext = {Q, 1'b0};

    // 2's complement of M
    assign M_Neg = -M;

    always @(*) begin
        partial = 64'sd0;

        for (i = 1; i < 32; i = i + 2) begin
            case ({Q_ext[i+1], Q_ext[i], Q_ext[i-1]})
                3'b001, 3'b010: partial = partial + ({{32{M[31]}},     M}      <<< (i-1)); // +1*M
                3'b011:         partial = partial + ({{31{M[31]}},     M, 1'b0}<<< (i-1)); // +2*M
                3'b100:         partial = partial + ({{31{M_Neg[31]}}, M_Neg,1'b0}<<< (i-1)); // -2*M
                3'b101, 3'b110: partial = partial + ({{32{M_Neg[31]}}, M_Neg}  <<< (i-1)); // -1*M
                default: ; // 000 and 111 do nothing
            endcase
        end

        // 32-bit datapath output: keep only the lower 32 bits (wrap)
        Result = partial[31:0];
    end

endmodule
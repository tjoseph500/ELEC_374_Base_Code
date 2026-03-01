module booth_multiplier (
    input  wire signed [31:0] M,
    input  wire signed [31:0] Q,
    output reg  signed [63:0] Result
);

    integer i;

    // 33-bit extend so negation works for M = 0x80000000
    wire signed [32:0] M_ext    = {M[31], M};
    wire signed [32:0] M_negext = -M_ext;

    // Booth recoding bits (treat as bits)
    wire [32:0] Q_ext = {Q, 1'b0};

    reg signed [63:0] partial;

    always @(*) begin
        partial = 64'sd0;

        // Radix-4 Booth: 16 steps (i = 1,3,...,31)
        for (i = 1; i < 32; i = i + 2) begin
            case ({Q_ext[i+1], Q_ext[i], Q_ext[i-1]})
                // +1*M
                3'b001, 3'b010:
                    partial = partial + ( {{31{M_ext[32]}},    M_ext}        <<< (i-1) );

                // +2*M
                3'b011:
                    partial = partial + ( {{30{M_ext[32]}},    M_ext, 1'b0}  <<< (i-1) );

                // -2*M
                3'b100:
                    partial = partial + ( {{30{M_negext[32]}}, M_negext,1'b0}<<< (i-1) );

                // -1*M
                3'b101, 3'b110:
                    partial = partial + ( {{31{M_negext[32]}}, M_negext}     <<< (i-1) );

                default: ; // 000 and 111 do nothing
            endcase
        end

        // KEEP FULL 64-BIT PRODUCT
        Result = partial;
    end

endmodule
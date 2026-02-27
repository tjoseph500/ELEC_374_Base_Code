module register64 #(parameter INIT = 64'h0)(
	input clear, clock, Zin, Zhighin, Zlowin,
	input [63:0]ALU_OUT,
	output wire [31:0]BusMuxOut
);
reg [31:0]q;

initial q = INIT;
always @ (posedge clock)
		begin
			if (clear) begin
				q <= {31{1'b0}};
			end
			else if (Zin)
			begin
				q <= ALU_OUT[31:0];
				if (Zhighin)
				begin
				q <= ALU_OUT[63:32];
				end
				else if (Zlowin)
				begin
				q <= ALU_OUT[31:0];
				end
			end
		end
	assign BusMuxOut = q[31:0];
endmodule

module register64 #(parameter INIT = 64'h0)(
	input clear, clock, Zin,
	input [63:0]ALU_OUT,
	output wire [31:0]BusMuxIn_Zhigh,
	output wire [31:0]BusMuxIn_Zlow
);
reg [63:0]q;

initial q = INIT;
always @ (posedge clock)
		begin
			if (clear) begin
				q <= {64{1'b0}};
			end
			else
			if (Zin)
			begin
				q <= ALU_OUT[63:0];
			end
		end
	assign BusMuxIn_Zlow = q[31:0];
	assign BusMuxIn_Zhigh = q[63:32];
endmodule

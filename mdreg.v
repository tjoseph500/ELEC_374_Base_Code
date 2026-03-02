module mdr
(
	input clear, clock, enable, read,
	input [31:0]BusMuxOut,
	input [31:0]Mdatain,
	output wire [31:0]BusMuxIn
	
);
	reg [31:0] mdrIn;
	initial mdrIn = 32'h0;
	
	always @(posedge clock)begin
		
		if (read==1)
		begin
			mdrIn <= Mdatain;
		end
		else begin
			mdrIn <= BusMuxOut;
		end
		
	end
	
   register mdr_1(clear, clock, enable, mdrIn, BusMuxIn); 
endmodule
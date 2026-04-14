module ram64bytes(
    input clk,
    input [5:0] a,
    input [7:0] din,
    output [7:0] dout,
    input we
    );
	 reg [7:0] mem[0:63];
	 assign dout = mem[a];	
	 integer i;
	 initial begin
		for (i=0;i<=63;i=i+1)
			mem[i] = i/8;
	 end
	 always @(posedge clk) begin
		if (we)
			mem[a] <= din;
	 end
endmodule
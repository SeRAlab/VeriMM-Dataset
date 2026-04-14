module top_module(d_0,d_1,d_2,d_3,d,dout);input  [7:0]  d_0;
    input  [7:0]  d_1;
	 input  [7:0]  d_2;
	 input  [7:0]  d_3;
    input  [1:0]  d;
    output [7:0]  dout;
	 reg    [7:0]  dout;

	 always@(*) begin
		 case(d)
			2'b11: dout=d_3;
			2'b10: dout=d_2;
			2'b01: dout=d_1;
			2'b00: dout=d_0;
		 endcase
	 end
endmodule
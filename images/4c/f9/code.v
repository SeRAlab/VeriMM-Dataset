module top_module(
	 output [15:0] yout,
	 input [15:0] ain,
	 input [4:0] bin
    );wire [15:0] inter0;
	 wire [15:0] inter1;
	 wire [15:0] inter2;
	 wire [15:0] inter3;
	 wire [15:0] inter4;
	 wire [3:0] bin2;
	 
	 assign bin2 = (bin[4]) ? (~bin[3:0]):(bin[3:0]);
	 
	 
	 genvar i;
	 generate
		for(i=1;i<16;i=i+1) begin : REVERSE_INPUT
			assign inter0[i] = (bin[4])?(ain[16-i]):(ain[i]);
		end
	 endgenerate
	 
	 assign inter0[0] = (bin[4])?(1'b0):(ain[0]);
	 
	 
	 assign inter1 = (bin2[3])? (inter0 << 8):(inter0);
	 
	 
	 assign inter2 = (bin2[2])? (inter1 << 4):(inter1);
	 
	 
	 assign inter3 = (bin2[1])? (inter2 << 2):(inter2);
	 
	 
	 assign inter4 = (bin2[0])? (inter3 << 1):(inter3);
	 
	 
	 
	 generate
		for(i=0;i<16;i=i+1) begin : REVERSE_OUTPUT
			assign yout[i] = (bin[4])?(inter4[15-i]):(inter4[i]);
		end
	 endgenerate
	

endmodule
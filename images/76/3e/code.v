module top_module(selec,a_bus_out,reg1_a_in,reg2_a_in,reg3_a_in);input [1:0] selec;
	input [15:0]reg1_a_in,reg2_a_in,reg3_a_in;
	output  reg [15:0] a_bus_out;
	always@(*) begin
		if(selec==2'b01) a_bus_out=reg1_a_in;
		else if(selec==2'b10) a_bus_out=reg2_a_in;
		else if(selec==2'b11) a_bus_out=reg3_a_in;
	end
	
endmodule
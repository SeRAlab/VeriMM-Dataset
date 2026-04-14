module top_module(input [7:0] DataIN,
						input clock, Reset_b,
						output [7:0] DataOUT);reg [7:0] DataOUTreg;
	always @ (posedge clock) begin
		if(Reset_b == 0)
			DataOUTreg <= 8'b00000000;
		else
			DataOUTreg <= DataIN;
	end
	assign DataOUT = DataOUTreg;endmodule
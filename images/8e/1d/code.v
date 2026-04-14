module top_module( signal_input, signal_output, serial_output, select,	new_bit, CLK);input [7:0]signal_input;
	input [1:0]select;
	input CLK, new_bit;
	output reg [7:0]signal_output;
	output reg serial_output;
	
	
	always@(posedge CLK)
	begin
		case(select)
		
			2'b00: signal_output <= signal_output;
			2'b01: signal_output <= signal_input;
			2'b10: 
			begin
			serial_output <= signal_input[0];
			signal_output <={new_bit,signal_input[7:1]};
			end
			
			2'b11: signal_output <={signal_input[6:0], new_bit};
			
		endcase
	end
			


endmodule
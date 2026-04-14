module top_module(
	input wire clk,
	output wire done,
	output reg en
);reg [1:0] state, nstate;
	reg [3:0] count;
	localparam start_bit = 2'b00, data_bit = 2'b01, parity = 2'b10, stop_bit = 2'b11;
	
	assign done = (state == 2'b00);
	
	always @ (*)
	begin
		state = nstate;		
	end
	
	always @ (negedge clk)	
	begin
		case (state)		
		start_bit: 		
			begin
				nstate <= data_bit;		
				en <= 1'b1;			
			end
						
		data_bit:	
			begin	
				if (count < 4'b0111)	
				begin
					en <= 1'b1;			
					count <= count + 1'b1;
				end
				else
				begin
					en <= 1'b0;			
					count <= 4'b0000;
					nstate <= parity;
				end
			end
				
		parity:	
			begin		
				nstate <= stop_bit;
				en <= 1'b0;
			end
		
		stop_bit:	
			begin		
				nstate <= start_bit;
				en <= 1'b0;
			end
				
		default:
			begin	
				nstate <= start_bit;	
				count <= 4'b0000;		
				en <= 1'b0;				
			end
		endcase
	end
endmodule
module top_module(clock, count, Tx, Ty, Tz, Tula);input wire clock;

input wire [2:0] count;

output reg Tula;
output reg [1:0] Tx;
output reg [1:0] Ty;
output reg [1:0] Tz;

parameter HOLD = 2'b00;
parameter LOAD = 2'b01;
parameter SHIFTR = 2'b10;
parameter RESET = 2'b11;

parameter ADD = 1'b0;

always @(posedge clock) begin
	case(count)
		3'b000 : begin			
			Tx <= LOAD;
			Ty <= RESET;
			Tz <= RESET;
			Tula <= ADD;
			end
			
		3'b001 : begin			
			Tx <= LOAD;
			Ty <= LOAD;
			Tz <= HOLD;
			Tula <= ADD;
			end
			
		3'b010 : begin		
			Tx <= LOAD;
			Ty <= LOAD;
			Tz <= HOLD;
			Tula <= ADD;
			end
			
		3'b011 : begin
			Tx <= HOLD;
			Ty <= SHIFTR;
			Tz <= HOLD;
			Tula <= ADD;
			end
			
		3'b100 : begin
			Tx <= RESET;
			Ty <= RESET;
			Tz <= LOAD;
			Tula <= ADD;
			end	
		3'b101 : begin
			Tx <= HOLD;
			Ty <= HOLD;
			Tz <= HOLD;
			Tula <= ADD;
			end	
	endcase
end
endmodule
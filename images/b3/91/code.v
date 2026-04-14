module top_module(
    input clk,
    input rst,
    input up_down,
	 input load,
	 input [7:0] data,
	 input [7:0]reset_variable,
    output reg [7:0] count
    );wire[7:0] add_b;
	 wire reset_comparador;
	 reg [7:0] adder_out;
	 reg [7:0] nxt_count;
	 
	
		assign add_b = up_down ? 1 : -1;
	
		always @ * begin
			adder_out = count + add_b;
		end
		
	
		always @ (posedge clk) begin
			
			if (rst | reset_comparador) begin
				count <= 0;
			end
			else begin
				count <= nxt_count;
			end
		end
		
	
		assign reset_comparador = (reset_variable==count) ? 1:0;
		
	
	always @ * begin
		nxt_count = load ? data: adder_out;
	end
		
endmodule
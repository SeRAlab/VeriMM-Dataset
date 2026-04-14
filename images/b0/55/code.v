module top_module(input read_city, input enable, input [2:0]select, output reg [1:0]city, output city_done_out);reg city_done = 1'b0;
	always @ (negedge enable) begin
	if (read_city) begin
		case(select[2:0])
		 3'b100: begin city = 2'b00; 
							city_done = 1'b1;
					end
		 3'b010: begin city = 2'b01; 
							city_done = 1'b1;
					end
		 3'b001: begin city = 2'b10; 
							city_done = 1'b1;
					end
		 default: city = 2'b00;
		endcase
	end
	else 
	    city_done = 1'b0;
	end
assign city_done_out = city_done;endmodule
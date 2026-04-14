module top_module(
    input wire a,
    input wire b,
    input wire c,
    output reg y,
    output reg z,
	 input wire clk
    );always @ (posedge clk) begin 
	case({a, b, c}) 
		3'b111:	begin 
					y <= 0; 
					z <= 1;
					end
		3'b110: 	begin 
					y <= 1;
					z <= 1;
					end
		3'b100: 	begin 
					y <= 0;
					z <= 0;
					end
		default: begin 
					y <= 0;
					z <= 1'bx;
					end
	endcase
end
endmodule
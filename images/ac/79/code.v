module top_module(
    output reg [5:0] counter,
    input clock,
    input rst_n,
    input dir
    );always @ (rst_n, clock) begin
		if(rst_n==1'b0) begin
			counter <= (dir) ? 6'b11_1111 : 6'b0;
			end
		else
			case(dir)
			1'b0: counter <= counter + 1'b1;
			1'b1: counter <= counter - 1'b1;
			default: begin
				if(dir==1'b0) counter <= 6'b0;
				else if(dir==1'b1) counter <= 6'b11_1111;
				end
			endcase
		 end
endmodule
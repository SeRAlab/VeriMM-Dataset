module top_module(clk, r0, r1, rw, d0, d1, dw, we);input clk, we;
	input [5:0] r0, r1, rw;
	input [31:0] dw;
	output reg [31:0] d0, d1;
	
	wire [5:0] rwr0;
	reg [31:0] iregfile[63:0];	

	
	
	assign rwr0 = (we == 1) ? rw : r0;
	always @ (posedge clk)
		begin
			if(we == 1) begin
				iregfile[rwr0] <= dw;
			end
			else begin
				d0 <= iregfile[rwr0];
			end
		end
	
	always @ (posedge clk)
		begin
			d1 <= iregfile[r1];
		end
endmodule
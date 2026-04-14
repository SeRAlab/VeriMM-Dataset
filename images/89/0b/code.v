module top_module(clk, rst, HADDR, ready, in_data, out_data, write, IPdata_in, IPdata_out) ;input clk, rst, ready;
input [31:0] HADDR;
input [31:0] in_data;
input [31:0] IPdata_out;


output reg [31:0] IPdata_in;
output reg [31:0] out_data;
output reg write;

always @ (posedge clk or posedge rst)
begin
	if (rst) begin
	IPdata_in = 32'd0;
	out_data  = 32'd0;
	write = 0;
	end
	else begin
	case (HADDR[0])
		1'd0	:	begin
					IPdata_in <= in_data;
					write = 1'd1;
					end
		1'd1	:	begin
					if(ready==1)
					out_data <= IPdata_out;
					else
					out_data <= out_data;
					end
		endcase
	end
  end               
endmodule
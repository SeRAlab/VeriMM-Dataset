module top_module(clk,reset_n,
	  mem_we,mem_waddr,mem_wdata,mem_whilo,mem_hi,mem_lo,
	  wb_we,wb_waddr,wb_wdata,wb_whilo,wb_hi,wb_lo);input            clk;
input            reset_n;




input            mem_we;
input      [4:0] mem_waddr;
input      [31:0]mem_wdata;
input            mem_whilo;
input      [4:0] mem_hi;
input      [31:0]mem_lo;




output reg       wb_we;
output reg [4:0] wb_waddr;
output reg [31:0]wb_wdata;
output reg       wb_whilo;
output reg [4:0] wb_hi;
output reg [31:0]wb_lo;

always @ (posedge clk or negedge reset_n) begin
	if(!reset_n) begin
		wb_we         <= 1'b0;
		wb_waddr[4:0] <= {5{1'b0}};
		wb_wdata[31:0]<= {32{1'b0}};
		wb_whilo      <= 1'b0;
		wb_hi   [4:0] <= {5{1'b0}};
		wb_lo  [31:0] <= {32{1'b0}};
	end else begin
		wb_we         <= mem_we;
		wb_waddr[4:0] <= mem_waddr[4:0];
		wb_wdata[31:0]<= mem_wdata[31:0];
		wb_whilo      <= mem_whilo;
		wb_hi   [4:0] <= mem_hi[4:0];
		wb_lo  [31:0] <= mem_lo[31:0];
	end
end


endmodule
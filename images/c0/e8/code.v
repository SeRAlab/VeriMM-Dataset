module bw_r_idct_array(we, clk, rd_data, wr_data, addr,dec_wrway_y,way);
input we;
input clk;
input [32:0] wr_data;
input [6:0] addr;
input [3:0] dec_wrway_y;
input [1:0] way;
output [32:0] rd_data;
reg [32:0] rd_data;
reg	[32:0]		array[511:0]  ;
integer i;
initial begin
`ifdef DO_MEM_INIT
    $readmemb("/import/dtg-data11/sandeep/niagara/design/sys/iop/srams/rtl/mem_init_idct.txt",array);
`endif
end
	always @(negedge clk) begin
	  if (we) 
          begin
              array[addr] <= wr_data;
          end
	  else 
          rd_data <= array[addr];
	end
endmodule
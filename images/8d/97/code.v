module top_module(
			rst_n,
			clk_108m,
			
			data_valid,
			din0,
			din1,
			
			out_fifo_wren,
			out_fifo_wdata
			);parameter		U_DLY = 1;

input										rst_n;
input										clk_108m;

input										data_valid;
input[7:0]							din0;
input[7:0]							din1;

output									out_fifo_wren;
output[15:0]						out_fifo_wdata;
reg											out_fifo_wren;
reg		[15:0]						out_fifo_wdata;
always @( posedge clk_108m or negedge rst_n )
begin
		if( ~rst_n )
		begin
				out_fifo_wren		<= 1'b0;
				out_fifo_wdata	<= 18'b0;
		end
		else
		begin
				out_fifo_wren		<= data_valid;
				out_fifo_wdata	<= {din0[7:0],din1[7:0]};
		end
end
endmodule
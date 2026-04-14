module top_module(outdata, sel, indata);parameter width = 8; 
parameter number_of_inputs = 4; 
parameter number_of_select_lines = 2; 

localparam total_num_of_input_bits= number_of_inputs * width;

input [total_num_of_input_bits-1:0] indata;
input [number_of_select_lines-1:0] sel;
output [width-1:0] outdata;

integer i;
reg[width-1:0] tmp, outdata; 

always @*
begin
	for(i=0; i < width; i = i + 1) 
	tmp[i] = indata[width*sel + i];
	outdata = tmp;
end

endmodule
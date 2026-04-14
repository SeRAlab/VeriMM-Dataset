module top_module(clr, ld, clk, data_in, data_out);input clr, ld, clk;
input [3:0] data_in;
output [3:0] data_out;
reg [3:0] data_out;

always@(posedge clr or posedge clk)
begin
    if (clr) data_out <= 0;
    else if (ld) data_out <= data_in;

end 
endmodule
module top_module(data_out, data_in);input [0:31] data_in;
output reg [0:31] data_out;

always@(data_in)
begin
data_out[0:23] = data_in[8:31];
data_out[24:31] = data_in[0:7];
end 

endmodule
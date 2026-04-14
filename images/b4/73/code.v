module top_module(
output[31:0]    out,
input           enable,
input[4:0]      address
);assign out = enable<<address; 
endmodule
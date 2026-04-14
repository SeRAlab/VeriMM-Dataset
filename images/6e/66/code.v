module top_module(
    input data,
    input reset_FFD,
    input clock,
    output q
    );reg g;
always @(posedge clock or posedge reset_FFD)
if (reset_FFD)
g<=1'b0;
else
g<=data;

assign q=g;


endmodule
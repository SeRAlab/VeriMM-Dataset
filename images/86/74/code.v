module top_module(
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  A4  ,
    input  B1  ,
    output Y   ,
    input  VPWR,
    input  VGND
);wire [3:0] OR_result;
wire [3:0] AND_result;

assign OR_result = A1 | A2 | A3 | A4;
assign AND_result = A1 & A2 & A3 & A4;

assign Y = B1 ? AND_result : OR_result;

endmodule
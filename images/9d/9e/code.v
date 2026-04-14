module top_module(
    input [11:0] digi_in,   
    output [6:0] digi_out1, 
    output [6:0] digi_out2, 
    output [6:0] digi_out3, 
    output [6:0] digi_out4  
);assign digi_out1=(digi_in[11:8]==4'b0001)?digi_in[6:0]:7'b111_1111;
assign digi_out2=(digi_in[11:8]==4'b0010)?digi_in[6:0]:7'b111_1111;
assign digi_out3=(digi_in[11:8]==4'b0100)?digi_in[6:0]:7'b111_1111;
assign digi_out4=(digi_in[11:8]==4'b1000)?digi_in[6:0]:7'b111_1111;

endmodule
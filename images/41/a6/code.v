module top_module(input SEL, input TRIGGERED, input [15:0] RAM_DATA, output [15:0] DATA);assign DATA=SEL?RAM_DATA:TRIGGERED;

endmodule
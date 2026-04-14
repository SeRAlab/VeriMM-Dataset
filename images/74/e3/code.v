module top_module(
    DataIn,
    DataOut1,
    DataOut2
);input [3:0] DataIn;
output [3:0] DataOut1;
wire [3:0] DataOut1;
output [3:0] DataOut2;
wire [3:0] DataOut2;





assign DataOut1 = DataIn;
assign DataOut2 = DataIn;

endmodule
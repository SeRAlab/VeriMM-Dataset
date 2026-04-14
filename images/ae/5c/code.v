module decoder2to4(
    input wire [1:0] in,
    output wire out0,
    output wire out1,
    output wire out2,
    output wire out3
    );

assign out0 = (in == 2'b00);
assign out1 = (in == 2'b01);
assign out2 = (in == 2'b10);
assign out3 = (in == 2'b11);

endmodule
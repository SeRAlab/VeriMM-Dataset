module top_module(
    input [1:0] select,
    input en,
    output [15:0] out
);assign out[0] = ~en & (select == 2'b00);
    assign out[1] = ~en & (select == 2'b01);
    assign out[2] = ~en & (select == 2'b10);
    assign out[3] = ~en & (select == 2'b11);
    assign out[4] = ~en & (select == 2'b00);
    assign out[5] = ~en & (select == 2'b01);
    assign out[6] = ~en & (select == 2'b10);
    assign out[7] = ~en & (select == 2'b11);
    assign out[8] = ~en & (select == 2'b00);
    assign out[9] = ~en & (select == 2'b01);
    assign out[10] = ~en & (select == 2'b10);
    assign out[11] = ~en & (select == 2'b11);
    assign out[12] = ~en & (select == 2'b00);
    assign out[13] = ~en & (select == 2'b01);
    assign out[14] = ~en & (select == 2'b10);
    assign out[15] = ~en & (select == 2'b11);

endmodule
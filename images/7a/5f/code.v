module top_module(
    input a,
    input b,
    input c,
    input d,
    output x,
    output y
);assign x = (a) ? 2'b00 : (b) ? 2'b01 : (c) ? 2'b10 : (d) ? 2'b11 : 2'b00;
    assign y = (a) ? 2'b00 : (b) ? 2'b00 : (c) ? 2'b01 : (d) ? 2'b01 : 2'b00;

endmodule
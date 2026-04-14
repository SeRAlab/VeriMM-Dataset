module top_module(input en, output reg y);always @*
    y = en & !y;
endmodule
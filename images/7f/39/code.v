module top_module(input clk, output val);parameter min = 0;
    parameter cycle = 16;

    reg [cycle-1:0] count;

    assign val = count > min;

    always @(posedge clk) count++;
endmodule
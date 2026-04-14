module top_module(output reg[31:0] out,
                       input[31:0] in,
                       input load_enable,
                       clk);always @(posedge clk)
    if (load_enable) out <= in;
endmodule
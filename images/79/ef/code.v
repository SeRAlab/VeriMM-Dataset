module top_module(input0, input1, out, clk);input wire [31:0] input0;
    input wire [31:0] input1;
    input wire clk;

    output reg[31:0] out;

    always@(posedge clk)
    begin
        out <= input0 + input1;
    end
endmodule
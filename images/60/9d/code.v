module top_module(
    input [3:0] D,
    input Clk,
    input reset,
    input set,
    input load,
    output reg [3:0] Q
    );always @(posedge Clk) begin
        if (reset) Q <= 4'b0000;
        else if (set) Q <= 4'b1111;
        else if (load) Q <= D;
    end
endmodule
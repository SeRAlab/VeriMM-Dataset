module top_module(
    input [3:0] D,
    input Clk,reset,load,
    output reg [3:0] Q
    );always @(posedge Clk)
    if (reset)
    begin
        Q <= 4'b0;
    end else if (load)
    begin
        Q <= D;
    end
endmodule
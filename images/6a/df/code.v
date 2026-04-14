module top_module(
    input Clk,reset,set,load,
    input [3:0] D,S,
    output reg [3:0] Q
    );always @(posedge Clk)
    if (reset)
    begin
        Q <= 4'b0;
    end else if (set)
    begin
        Q <= S;
    end else if (load)
    begin
        Q <= D;
    end
endmodule
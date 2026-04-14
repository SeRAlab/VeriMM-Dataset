module top_module(
    input [width-1:0] A,
    input Clk,
    output reg [width-1:0] Z
    );parameter width = 8;
    always @(posedge Clk)
    begin
        Z <= A;
    end
endmodule
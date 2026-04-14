module top_module(
    input D,Clk,reset,ce,
    output reg Q
    );always @(posedge Clk)
    if (reset)
    begin
        Q <= 1'b0;
    end else if (ce)
    begin
        Q <= D;
    end
endmodule
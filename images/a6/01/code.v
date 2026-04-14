module top_module(
    input Clk,reset_n, T,
    output reg Q
    );always @(negedge Clk)
    if (!reset_n)
        Q <= 1'b0;
    else if (T)
        Q <= ~Q;
endmodule
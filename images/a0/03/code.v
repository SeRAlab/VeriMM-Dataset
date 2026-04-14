module top_module(
    input Clk,
    input T,
    input reset_n,
    output reg Q
    );always @(negedge Clk) begin
        if (!reset_n) Q <= 1'b0;
        else if (T) Q <= ~Q;
    end
endmodule
module top_module(
    input a,
    input b,
    input clk,
    output reg out
);reg or_out;
    reg d_ff_out;

    assign or_out = a | b;

    always @(posedge clk) begin
        d_ff_out <= or_out ^ d_ff_out;
        out <= d_ff_out;
    end

endmodule
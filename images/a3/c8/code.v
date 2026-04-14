module top_module(input t, input clk, output reg q);reg d1, d2;
    always @(posedge clk) begin
        d1 <= t;
    end
    always @(posedge clk) begin
        d2 <= d1;
    end
    assign q = d1 ^ d2;
endmodule
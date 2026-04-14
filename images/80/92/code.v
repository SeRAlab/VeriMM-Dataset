module top_module(
    input clk,
    input d,
    input t,
    output reg q );always @(posedge clk) begin
        if (t) begin
            q <= ~q;
        end else begin
            q <= d;
        end
    end

endmodule
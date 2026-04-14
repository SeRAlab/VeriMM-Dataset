module top_module(
    input wire clk,
    input wire reset,
    output reg q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= ~q;
        end
    end

endmodule
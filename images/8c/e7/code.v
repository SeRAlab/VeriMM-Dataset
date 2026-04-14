module top_module(
    input clk,
    input d,
    output reg q
);always @(posedge clk) begin
        q <= d; // Directly assign d to q on rising edge of clk
    end

endmodule
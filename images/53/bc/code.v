module top_module(
    input clk,
    input shift_parallel,
    input [3:0] parallel_in,
    output reg [3:0] out
);always @(posedge clk) begin
        if (shift_parallel) begin
            out <= {out[2:0], 1'b0};
        end
        else begin
            out <= parallel_in;
        end
    end

endmodule
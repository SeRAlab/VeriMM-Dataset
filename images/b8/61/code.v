module top_module(
    input [3:0] data_in,
    input shift,
    input load,
    input clk,
    output reg [3:0] out
);always @(posedge clk) begin
        if (load) begin
            out <= data_in;
        end else if (shift) begin
            out <= {out[2:0], 1'b0};
        end
    end

endmodule
module top_module(
    input clk,
    input [2:0] D,
    input L,
    input U,
    output reg [2:0] out
);always @(posedge clk) begin
        if (L) begin
            out <= D;
        end else begin
            if (U) begin
                out <= out + 1;
            end else begin
                out <= out - 1;
            end
        end
    end

endmodule
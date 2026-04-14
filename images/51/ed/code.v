module top_module(
    input clk,
    input rst,
    output reg [2:0] out,
    output reg carry_out
);always @(posedge clk) begin
        if (rst) begin
            out <= 3'b0;
            carry_out <= 1'b0;
        end
        else if (out == 3'b111) begin
            out <= 3'b0;
            carry_out <= 1'b1;
        end
        else begin
            out <= out + 1;
            carry_out <= 1'b0;
        end
    end

endmodule
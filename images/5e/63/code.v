module top_module(
    input clk,
    input rst,
    input up_down,
    input enable,
    output reg [3:0] out
);always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0;
    end else if (enable) begin
        if (up_down) begin
            out <= (out == 4'b1111) ? 4'b0 : out + 1;
        end else begin
            out <= (out == 4'b0000) ? 4'b1111 : out - 1;
        end
    end
end

endmodule
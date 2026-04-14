module top_module(
    input clk,
    input rst,
    output reg [3:0] out
);always @(posedge clk) begin
        if (rst) begin
            out <= 4'd0;
        end else begin
            if (out == 4'd15) begin
                out <= 4'd0;
            end else begin
                out <= out + 1;
            end
        end
    end

endmodule
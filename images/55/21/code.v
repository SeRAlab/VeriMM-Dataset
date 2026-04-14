module top_module(
    input clk,
    input up_down,
    input reset,
    output reg [3:0] out
);always @(posedge clk) begin
        if (reset) begin
            out <= 4'b0;
        end else begin
            if (up_down) begin
                out <= out + 4'b1;
            end else begin
                out <= out - 4'b1;
            end
        end
    end

endmodule
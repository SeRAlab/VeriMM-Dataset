module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count_out
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            count_out <= 4'b0000;
        end else if (enable) begin
            if (count_out == 4'b1001) begin
                count_out <= 4'b0000;
            end else begin
                count_out <= count_out + 1;
            end
        end
    end

endmodule
module top_module(
    input clk,
    input reset,
    input count_en,
    input [31:0] max_count,
    output reg [31:0] count
);always @(posedge clk or negedge reset) begin
        if (!reset) begin
            count <= 0;
        end else if (count_en) begin
            if (count == max_count) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
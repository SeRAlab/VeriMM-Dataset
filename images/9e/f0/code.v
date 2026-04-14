module top_module(
    input [3:0] a, b,
    output reg [2:0] comparison_result
);always @(*) begin
        if (a > b) begin
            comparison_result = 3'b001;
        end else if (a < b) begin
            comparison_result = 3'b010;
        end else begin
            comparison_result = 3'b100;
        end
    end

endmodule
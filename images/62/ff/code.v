module top_module(
    input clk,
    input reset,
    input [7:0] max_count,
    output reg [7:0] count_out
);always @(posedge clk) begin
    if (reset == 1'b0) begin
        count_out <= 8'h00;
    end else if (count_out == max_count) begin
        count_out <= 8'h00;
    end else begin
        count_out <= count_out + 1;
    end
end

endmodule
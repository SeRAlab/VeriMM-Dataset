module top_module(
    input clk,
    input [7:0] max_count,
    output reg [7:0] count
);always @(posedge clk) begin
        if (count == max_count) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule
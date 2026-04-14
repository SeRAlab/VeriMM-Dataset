module top_module(
    input clk,
    input rst,
    input en,
    input [31:0] count_to,
    output reg [31:0] count
);always @(posedge clk) begin
        if (rst) begin
            count <= 0;
        end else if (en) begin
            if (count == count_to) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
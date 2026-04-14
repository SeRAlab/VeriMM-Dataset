module top_module(
    input clk,
    input rst,
    output reg [3:0] count,
    output reg overflow
);always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0;
            overflow <= 1'b0;
        end
        else if (count == 4'b1111) begin
            count <= 4'b0;
            overflow <= 1'b1;
        end
        else begin
            count <= count + 1;
            overflow <= 1'b0;
        end
    end

endmodule
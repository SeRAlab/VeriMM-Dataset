module top_module(
    input clk,
    input rst,
    output reg [2:0] count
);always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            count <= 3'b000;
        end else if (count == 3'b111) begin
            count <= 3'b000;
        end else begin
            count <= count + 1;
        end
    end

endmodule
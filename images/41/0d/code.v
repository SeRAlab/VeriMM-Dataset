module top_module(
    input wire clk,
    input wire data,
    input wire rst,
    output reg q
);always @ (posedge clk or negedge rst) begin
        if (rst == 1'b1) begin
            q <= 1'b0;
        end
        else begin
            q <= data;
        end
    end
endmodule
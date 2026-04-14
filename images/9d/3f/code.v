module top_module(
    input clk,
    input rst,
    output reg [2:0] count_out
);always @ (posedge clk or posedge rst) begin
        if (rst) begin
            count_out <= 3'b0;
        end
        else begin
            count_out <= count_out + 1;
        end
    end

endmodule
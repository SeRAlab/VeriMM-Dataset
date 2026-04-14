module divide_by_4(
    input clk,
    input rst,
    input [1:0] value,
    output reg [1:0] result
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 2'b00;
        end else begin
            result <= value / 4;
        end
    end
endmodule
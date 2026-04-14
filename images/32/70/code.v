module divide_by_4(
    input [1:0] in,
    input clk,
    input rst,
    output reg [1:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 2'b00;
        end else begin
            out <= in >> 2; // Divide by 4
        end
    end
endmodule
module divide_by_4 (
    input clk,
    input rst,
    input [3:0] in,
    output reg [1:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 2'b00;
        end else begin
            out <= in[3:2]; // Take the two most significant bits of the input
        end
    end
endmodule
module divide_by_2 (
    input wire clk,
    input wire rst,
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 8'b0;
        end else begin
            out <= in >> 1; // Divide by 2 operation
        end
    end
endmodule
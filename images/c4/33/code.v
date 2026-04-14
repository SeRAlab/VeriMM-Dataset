module keypad_scanner (
    input clk,
    input [3:0] col,
    output reg [3:0] row
);

reg [3:0] row_temp;

always @(posedge clk) begin
    row_temp <= 4'b1110;
    if (col[0] == 1) row_temp <= 4'b1101;
    if (col[1] == 1) row_temp <= 4'b1011;
    if (col[2] == 1) row_temp <= 4'b0111;
    if (col[3] == 1) row_temp <= 4'b1110;
end

always @(posedge clk) begin
    row <= row_temp;
end

endmodule
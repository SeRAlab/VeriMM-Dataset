module top_module(
    input RESET, DIR, CLK,
    input [3:0] binary,
    output reg [3:0] gray,
    output reg [3:0] binary_out
);reg [3:0] binary_reg1, binary_reg2;
reg [3:0] gray_reg1, gray_reg2;

always @(posedge CLK) begin
    if (RESET) begin
        binary_reg1 <= 4'b0;
        binary_reg2 <= 4'b0;
        gray_reg1 <= 4'b0;
        gray_reg2 <= 4'b0;
    end else begin
        binary_reg1 <= binary;
        binary_reg2 <= binary_reg1;
        gray_reg1 <= (binary_reg1 ^ binary_reg2) >> 1;
        gray_reg2 <= gray_reg1;
    end
end

always @(*) begin
    if (DIR) begin
        gray = gray_reg1;
        binary_out = binary_reg1;
    end else begin
        gray = gray_reg2;
        binary_out = binary_reg2;
    end
end

endmodule
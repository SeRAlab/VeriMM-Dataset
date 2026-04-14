module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,               // Added clk input
    output reg [7:0] P      // Changed assignment of P to reg type
);reg [3:0] A_reg, B_reg;
reg [4:0] P_reg;
reg [2:0] count;

always @(*) begin
    A_reg = A;
    B_reg = B;
    P_reg = 0;
    count = 4;
end

always @(posedge clk) begin
    if (count > 0) begin
        if (B_reg[0] == 1 && P_reg[0] == 0) begin
            P_reg = P_reg - A_reg;
        end else if (B_reg[0] == 0 && P_reg[0] == 1) begin
            P_reg = P_reg + A_reg;
        end
        if (P_reg[0] == 1) begin
            P_reg = P_reg + (1 << 4);
        end
        A_reg = A_reg << 1;
        B_reg = B_reg >> 1;
        count = count - 1;
    end
end

always @(*) begin
    P = P_reg[7:0];  // Update P as per P_reg[7:0]
end

endmodule
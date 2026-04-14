module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);reg [7:0] P_reg;
reg [4:0] B_reg;
reg [4:0] A_reg;
reg [2:0] i;

always @(*) begin
    P_reg = 0;
    B_reg = {1'b0, B};
    A_reg = {1'b0, A};
    for (i = 0; i < 4; i = i + 1) begin
        if (B_reg[1:0] == 2'b01) begin
            P_reg = P_reg + (A_reg << (2*i));
        end else if (B_reg[1:0] == 2'b10) begin
            P_reg = P_reg + (A_reg << (2*i+1));
        end
        if (B_reg[0] == 1'b0) begin
            B_reg = B_reg >> 1;
        end else begin
            B_reg = B_reg + 4'b1111;
        end
    end
    P = P_reg;
end

endmodule
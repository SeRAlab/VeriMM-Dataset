module top_module(
    input [15:0] A,
    input [15:0] B,
    input C,
    output reg [31:0] P
);reg [15:0] a_reg, b_reg, b_neg;
reg [4:0] i;
reg [15:0] B_temp; // Temporary register to hold the adjusted value of B

always @(*) begin
    a_reg = (C == 1 && A[15] == 1) ? ~A + 1 : A;
    b_reg = (C == 1 && B[15] == 1) ? ~B + 1 : B;
    b_neg = ~b_reg + 1;
    P = 0;
    B_temp = b_reg; // Use temporary register for modification
    
    for (i = 0; i < 16; i = i + 1) begin
        if (B_temp[0] == 1 && i == 0) begin
            P = P - a_reg;
        end else if (B_temp[0] == 0 && i == 0) begin
            P = P + a_reg;
        end else begin
            if (B_temp[0] == 1 && B_temp[1] == 0) begin
                P = P - (a_reg << i);
            end else if (B_temp[0] == 0 && B_temp[1] == 1) begin
                P = P + (a_reg << i);
            end
        end
        B_temp = {B_temp[14:0], B_temp[15]}; // Rotate the bits in the temporary B
    end
    P = (C == 1 && P[31] == 1) ? ~P + 1 : P;
end

endmodule
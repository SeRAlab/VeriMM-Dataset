module top_module(
    input A, B, C, EN,
    output reg Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7
);reg [2:0] A_reg, B_reg, C_reg;
reg [7:0] Y_reg;

always @(posedge EN) begin
    A_reg <= A;
    B_reg <= B;
    C_reg <= C;
    Y_reg <= 8'b0;
end

always @(posedge EN) begin
    case ({A_reg, B_reg, C_reg})
        3'b000: Y_reg[0] <= 1'b1;
        3'b001: Y_reg[1] <= 1'b1;
        3'b010: Y_reg[2] <= 1'b1;
        3'b011: Y_reg[3] <= 1'b1;
        3'b100: Y_reg[4] <= 1'b1;
        3'b101: Y_reg[5] <= 1'b1;
        3'b110: Y_reg[6] <= 1'b1;
        3'b111: Y_reg[7] <= 1'b1;
    endcase
end

assign Y0 = Y_reg[0];
assign Y1 = Y_reg[1];
assign Y2 = Y_reg[2];
assign Y3 = Y_reg[3];
assign Y4 = Y_reg[4];
assign Y5 = Y_reg[5];
assign Y6 = Y_reg[6];
assign Y7 = Y_reg[7];

endmodule
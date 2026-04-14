module top_module(
    input clk,
    input sof,
    input [79:0] A,
    input [15:0] B,
    output reg [179:0] C,
    output reg [4:0] valid
);reg [79:0] A_reg;
reg [15:0] B_reg;
reg [79:0] A_shifted;
reg [15:0] B_shifted;
reg [95:0] AB_mult;
reg [175:0] C_reg;

always @(posedge clk) begin
    if (sof) begin
        A_reg <= A;
        B_reg <= B;
        valid <= 0;
        C_reg <= 0;
    end else begin
        A_reg <= A_reg;
        B_reg <= B_reg;
        valid <= 0;
        C_reg <= C_reg;
    end
end

always @(A_reg, B_reg) begin
    A_shifted = {A_reg, 24'h0};
    B_shifted = {16'h0, B_reg};
    AB_mult = A_shifted * B_shifted;
    C_reg = {AB_mult[175:96], AB_mult[95:16], AB_mult[15:0]};
    valid = 1;
end

assign C = C_reg;

endmodule
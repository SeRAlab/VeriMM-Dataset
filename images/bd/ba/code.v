module top_module(
    input CLK,
    input [15:0] A, B, C, D,
    output [31:0] O,
    output CO // Currently unused, left in case we want to support signed operations in the future.
);parameter [0:0] A_REG = 0;
    parameter [0:0] B_REG = 0;
    parameter [0:0] C_REG = 0;
    parameter [0:0] D_REG = 0;
    parameter [0:0] ENABLE_DSP = 0;
    parameter [0:0] A_SIGNED = 0;
    parameter [0:0] B_SIGNED = 0;

    wire [15:0] iA, iB, iC, iD;
    wire [31:0] iF, iJ, iK, iG;

    // Regs C and A, currently unused
    reg [15:0] rC, rA;

    assign iC = C_REG ? rC : C;
    assign iA = A_REG ? rA : A;

    // Regs B and D, currently unused
    reg [15:0] rB, rD;

    assign iB = B_REG ? rB : B;
    assign iD = D_REG ? rD : D;

    // Multiplier Stage
    wire [31:0] p_Ah_Bh, p_Al_Bh, p_Ah_Bl, p_Al_Bl;
    wire [31:0] Ah, Al, Bh, Bl;
    assign Ah = {A_SIGNED ? {16{iA[15]}} : 16'b0, iA[15: 0]};
    assign Al = {16'b0, iA[ 7: 0]};
    assign Bh = {B_SIGNED ? {16{iB[15]}} : 16'b0, iB[15: 0]};
    assign Bl = {16'b0, iB[ 7: 0]};
    assign p_Ah_Bh = Ah * Bh; // F
    assign p_Al_Bh = {16'b0, Al[7:0]} * Bh; // J
    assign p_Ah_Bl = Ah * {16'b0, Bl[7:0]}; // K
    assign p_Al_Bl = Al * Bl; // G

    assign iF = p_Ah_Bh;
    assign iJ = p_Al_Bh;

    assign iK = p_Ah_Bl;
    assign iG = p_Al_Bl;

    // Adder Stage
    wire [39:0] iK_e = {A_SIGNED ? {16{iK[31]}} : 16'b0, iK};
    wire [39:0] iJ_e = {B_SIGNED ? {16{iJ[31]}} : 16'b0, iJ};
    assign O = ENABLE_DSP ? iG + (iK_e << 16) + (iJ_e << 16) + (iF << 32) : iA + iC;

endmodule
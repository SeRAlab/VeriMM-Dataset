module top_module(
    input CLK,
    input [15:0] A, B, C, D,
    output [31:0] O,
    output CO 
);parameter [0:0] A_REG = 0;
    parameter [0:0] B_REG = 0;
    parameter [0:0] C_REG = 0;
    parameter [0:0] D_REG = 0;
    parameter [0:0] ENABLE_DSP = 0;
    parameter [0:0] A_SIGNED = 0;
    parameter [0:0] B_SIGNED = 0;

    wire [15:0] iA, iB, iC, iD;
    wire [15:0] iF, iJ, iK, iG;

    
    reg [15:0] rC, rA;

    assign iC = C_REG ? rC : C;
    assign iA = A_REG ? rA : A;

    
    reg [15:0] rB, rD;

    assign iB = B_REG ? rB : B;
    assign iD = D_REG ? rD : D;

    
    wire [15:0] p_Ah_Bh, p_Al_Bh, p_Ah_Bl, p_Al_Bl;
    wire [15:0] Ah, Al, Bh, Bl;
    assign Ah = {A_SIGNED ? {8{iA[15]}} : 8'b0, iA[15: 8]};
    assign Al = {8'b0, iA[ 7: 0]};
    assign Bh = {B_SIGNED ? {8{iB[15]}} : 8'b0, iB[15: 8]};
    assign Bl = {8'b0, iB[ 7: 0]};
    assign p_Ah_Bh = Ah * Bh; 
    assign p_Al_Bh = {8'b0, Al[7:0]} * Bh; 
    assign p_Ah_Bl = Ah * {8'b0, Bl[7:0]}; 
    assign p_Al_Bl = Al * Bl; 

    assign iF = p_Ah_Bh;
    assign iJ = p_Al_Bh;

    assign iK = p_Ah_Bl;
    assign iG = p_Al_Bl;

    
    wire [23:0] iK_e = {A_SIGNED ? {8{iK[15]}} : 8'b0, iK};
    wire [23:0] iJ_e = {B_SIGNED ? {8{iJ[15]}} : 8'b0, iJ};
    assign iL = iG + (iK_e << 8) + (iJ_e << 8) + (iF << 16);

    
    assign O = iL;

endmodule
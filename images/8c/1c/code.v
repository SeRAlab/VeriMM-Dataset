module top_module(
    input [31:0] IR_D,
    input [1:0] A3_SEL,
    output [4:0] A3,
    input [31:0] RF_RT,
    input [31:0] imm_ext,
    input ALUB_SEL,
    output [31:0] ALUB,
    input [31:0] RDATA,
    input [31:0] RES_ALU_W,
    input [31:0] PC8_W,
    input [1:0] WD3_SEL,
    output [31:0] WD3,
    input [31:0] RES_ALU_E,
    input [31:0] HL_E,
    input AO_SEL_E,
    output [31:0] AO_E
    );wire[4:0] rt, rd;
    assign {rt, rd} = IR_D[20:11];
    
    assign A3 = (A3_SEL == 2'b00)? rt:
                (A3_SEL == 2'b01)? rd:
                (A3_SEL == 2'b10)? 5'h1f:
                                   rt;

    assign ALUB = (ALUB_SEL == 1'b1)? imm_ext : RF_RT;                                   

    assign WD3 = (WD3_SEL == 2'b00)? RES_ALU_W:
                 (WD3_SEL == 2'b01)? RDATA:
                 (WD3_SEL == 2'b10)? PC8_W:
                                     RES_ALU_W;   

    assign AO_E = AO_SEL_E? HL_E : RES_ALU_E;

endmodule
module NANOCODE_DECODER(input [16:0] NANO_ROM_IN , output EP_o , output CP_o , output LM_o , output CE_o , output LI_o , output EI_o , output CS_o , output LA_o , output EA_o , output SU_o , output AD_o , output EU_o , output LB_o , output LO_o , output LOAD_MICRO_o , output CLEAR_MICRO_o , output INC_MICRO_o);
assign EP_o = NANO_ROM_IN[16];
assign CP_o = NANO_ROM_IN[15];
assign LM_o = NANO_ROM_IN[14];
assign CE_o = NANO_ROM_IN[13];
assign LI_o = NANO_ROM_IN[12];
assign EI_o = NANO_ROM_IN[11];
assign CS_o = NANO_ROM_IN[10];
assign LA_o = NANO_ROM_IN[9];
assign EA_o = NANO_ROM_IN[8];
assign SU_o = NANO_ROM_IN[7];
assign AD_o = NANO_ROM_IN[6];
assign EU_o = NANO_ROM_IN[5];
assign LB_o = NANO_ROM_IN[4];
assign LO_o = NANO_ROM_IN[3];
assign LOAD_MICRO_o = NANO_ROM_IN[2];
assign CLEAR_MICRO_o = NANO_ROM_IN[1];
assign INC_MICRO_o = NANO_ROM_IN[0];
endmodule
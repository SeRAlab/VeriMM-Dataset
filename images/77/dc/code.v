module top_module(input clk_i,input rst_i,input [31:0] EI_adr,input DI_bra,input DI_jmp,input [31:0] DI_jmp_target,input [31:0] DI_adr,input EX_bra_confirm,input EX_jr,input [31:0] EX_adr,input [31:0] EX_adresse,input EX_cleared,output reg PR_bra_cmd,output reg PR_bra_bad,output reg [31:0] PR_bra_adr,output reg PR_clear_EI,output reg PR_clear_DI);parameter nb_record = 2 ; 
  parameter nb_record_width = 1; 
  `define BRA_ADDR [31:0] 
  `define CODE_ADDR [63:32] 
  `define LAST_BRA [64] 
  `define VALID [65] 
  always @(EX_adresse, EX_bra_confirm) 
  begin:PREDICT_SECTION1 
  PR_bra_cmd = 0; 
  PR_bra_bad = 0; 
  PR_bra_adr = 0; 
  PR_clear_DI = 0; 
  PR_clear_EI = 0; 
  if( EX_bra_confirm) 
  begin 
  PR_bra_bad = 1; 
  PR_bra_adr = EX_adresse; 
  PR_clear_EI = 1; 
  PR_clear_DI = 1; 
  end 
  if(DI_jmp) 
  begin 
  PR_bra_bad = 1; 
  PR_bra_adr = DI_jmp_target; 
  PR_clear_EI = 1; 
  end 
  end 
 endmodule
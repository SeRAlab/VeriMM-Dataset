module top_module(
    input [2:0] state,
    input prefix,
    input need_modrm,
    input need_off,
    input need_imm,
    input end_seq,
    input [5:0] ftype,
    input of,
    input next_in_opco,
    input next_in_exec,
    input block,
    input div_exc,
    input tflm,
    input intr,
    input iflm,
    input nmir,
    input iflss,
    output [2:0] next_state
  );parameter opcod_st = 3'h0;
  parameter modrm_st = 3'h1;
  parameter offse_st = 3'h2;
  parameter immed_st = 3'h3;
  parameter execu_st = 3'h4;
  wire into, end_instr, end_into;
  wire [2:0] n_state;
  wire       intr_iflm;
  wire       intrs_tni;

  
  assign into = (ftype==6'b111_010);
  assign end_into = into ? ~of : end_seq;
  assign end_instr = !div_exc && !intrs_tni && end_into && !next_in_exec;
  assign intr_iflm = intr & iflm;
  assign intrs_tni = (tflm | nmir | intr_iflm) & iflss;

  assign n_state = (state == opcod_st) ? (prefix ? opcod_st
                         : (next_in_opco ? opcod_st
                         : (need_modrm ? modrm_st
                         : (need_off ? offse_st
                         : (need_imm ? immed_st : execu_st)))))
                     : (state == modrm_st) ? (need_off ? offse_st
                                           : (need_imm ? immed_st : execu_st))
                     : (state == offse_st) ? (need_imm ? immed_st : execu_st)
                     : (state == immed_st) ? (execu_st)
    : (end_instr ? opcod_st : execu_st);

  assign next_state = block ? state : n_state;
endmodule
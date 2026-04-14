module top_module(
    input [1:0] prefix,
    input [7:1] opcode,
    input cx_zero,
    input zf,
    input ext_int,
    output next_in_opco,
    output next_in_exec,
    output use_eintp
  );wire exit_z, cmp_sca, exit_rep, valid_ops;

  
  assign cmp_sca = opcode[7] & opcode[2] & opcode[1];
  assign exit_z = prefix[0] ?  (cmp_sca ? ~zf : 1'b0 )
                            :  (cmp_sca ? zf : 1'b0 );
  assign exit_rep = cx_zero | exit_z;
  assign valid_ops = (opcode[7:1]==7'b1010_010   
                   || opcode[7:1]==7'b1010_011   
                   || opcode[7:1]==7'b1010_101   
                   || opcode[7:1]==7'b0110_110   
                   || opcode[7:1]==7'b0110_111   
                   || opcode[7:1]==7'b1010_110   
                   || opcode[7:1]==7'b1010_111); 
  assign next_in_exec = prefix[1] && valid_ops && !exit_rep && !ext_int;
  assign next_in_opco = prefix[1] && valid_ops && cx_zero;
  assign use_eintp    = prefix[1] && valid_ops && !exit_z;
  
endmodule
module top_module(jr, EX_MEM_RW, EX_MEM_RD, RS, FJA);input jr, EX_MEM_RW;
input[3:0] EX_MEM_RD, RS;
output [1:0] FJA;

assign FJA = (EX_MEM_RW && (EX_MEM_RD == RS)&&jr&&(~(RS == 4'hf))) ? 2'b01:     
      					   (~(RS == 4'hf)) ? 2'b10:     
                                                          2'b00;     

endmodule
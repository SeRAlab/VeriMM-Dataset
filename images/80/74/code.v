module top_module( EXTop,imm16,extout);input [15:0]  imm16;
    input [1:0]   EXTop;
    output [31:0] extout;
    
    assign extout = (EXTop == 'b00) ? { imm16,16'b0}:
                      (EXTop == 'b01) ? { 16'b0,imm16}:
                      (EXTop == 'b10) ? { {16{imm16[15]}},imm16}:
                      32'b0001001000110100;
endmodule
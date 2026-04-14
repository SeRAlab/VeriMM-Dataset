module top_module(input wire[27:0] Inst, input wire[31:28] PC, output reg[31:0] jump);always @ (*) jump <= {PC,Inst};

endmodule
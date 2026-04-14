module top_module(
    input           [15:0]                              imm ,
    input                                               expand  ,
    output          [31:0]                              expand_imm
    );assign expand_imm = expand ? {{16{imm[15]}}, imm} : {16'h0, imm};

endmodule
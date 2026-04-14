module top_module(
    input   [31:0]      A,
    input   [31:0]      B,
    output  [31:0]      R   
    );wire    [32:0]      R_tmp;         
    assign      R_tmp   = A + B;
    assign      R       = R_tmp[31:0];
endmodule
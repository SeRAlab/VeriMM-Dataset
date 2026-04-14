module top_module(
    input [3:0] bin,
    output [3:0] rotated);assign rotated = {bin[2:0], bin[3]};

endmodule
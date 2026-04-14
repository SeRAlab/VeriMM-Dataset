module top_module(
    input [4:0]a1,
    input [4:0]a2,
    input [4:0]a3,
    input [4:0]a4,
    input [1:0]choose,
    output [4:0]z
    );assign z=(choose[0])?(choose[1]?a4:a2):(choose[1]?a3:a1);

    
endmodule
module top_module(sign16, sign32);input [15:0] sign16;
    output [31:0] sign32;
    
    assign sign32 = sign16;
    
endmodule
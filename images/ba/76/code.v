module top_module(
    input MA,
    input [31:0] PC_1, A_DATA,
    output [31:0] Bus_A
    );assign Bus_A = (!MA)? A_DATA : PC_1; 
    
endmodule
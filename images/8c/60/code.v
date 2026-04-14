module top_module(
    
    input [15:0] immed,
    output [31:0] extended    
);assign extended = {{16 {immed[15]}}, immed[15:0]}; 
 
endmodule
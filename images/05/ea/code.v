module barrel_shifter (  
    input [1:0] in,  
    input shift,  
    output [1:0] out  
);  
    assign out = (shift == 1'b0) ? {in[0], 1'b0} : {1'b0, in[1]};  
endmodule
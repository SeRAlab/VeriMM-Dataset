module morphological_dilation(  
    input [2:0] in_row0,  
    input [2:0] in_row1,  
    input [2:0] in_row2,  
    output reg out  
);  
    always @(*) begin  
        out = (in_row0[0] | in_row0[1] | in_row0[2] |  
               in_row1[0] | in_row1[1] | in_row1[2] |  
               in_row2[0] | in_row2[1] | in_row2[2]);  
    end  
endmodule
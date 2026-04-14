module barrel_shifter (  
    input [1:0] in,  
    input shift,  
    output reg [1:0] out  
);  
    always @(*) begin  
        case (shift)  
            1'b0: out = {in[0], in[1]}; // Left shift  
            1'b1: out = {in[1], in[0]}; // Right shift  
            default: out = 2'bxx;  
        endcase  
    end  
endmodule
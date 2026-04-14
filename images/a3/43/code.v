module top_module(
    input CS, 
    
    
    input A0,
    input A1,
    output [3:0] enable 
);assign enable = CS == 1'b1 ? 4'b0000 :
                {A1, A0} == 2'b00 ? 4'b0001 : 
                {A1, A0} == 2'b01 ? 4'b0010 : 
                {A1, A0} == 2'b10 ? 4'b0100 :
                {A1, A0} == 2'B11 ? 4'b1000 : 4'b0000;

endmodule
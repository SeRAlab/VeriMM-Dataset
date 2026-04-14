module mux_8bit(  
    input [7:0] A,  
    input [7:0] B,  
    input S,  
    output [7:0] Y  
);  
    assign Y = (S) ? B : A;  
endmodule
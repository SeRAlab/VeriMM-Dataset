module mux4to1_4bit(Y, A, B, C, D, S0, S1);

    input [3:0] A, B, C, D;
    input S0, S1;
    output [3:0] Y;
    
    wire [3:0] AB, CD, Y_temp;
    
    assign AB = (S0 & ~S1) ? B : A;
    assign CD = (S0 & S1) ? D : C;
    assign Y_temp = (S0 | S1) ? CD : AB;
    assign Y = Y_temp;
    
endmodule
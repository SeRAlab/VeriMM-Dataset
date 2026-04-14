module xnor_3input(  
    input A,  
    input B,  
    input C,  
    output Y  
);  
    assign Y = ~(A ^ B ^ C);  
endmodule
module xnor_gate_3input (  
    input A,  
    input B,  
    input C,  
    output Y  
);  
    assign Y = ~(A ^ B ^ C) & (A | B | C);  
endmodule
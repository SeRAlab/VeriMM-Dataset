module comparator_2bit (  
    input [1:0] A,  
    input [1:0] B,  
    output G,  
    output L,  
    output E  
);  
    assign G = (A > B);  
    assign L = (A < B);  
    assign E = (A == B);  
endmodule
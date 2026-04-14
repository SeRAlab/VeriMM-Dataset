module twos_complement (  
    input [4:0] binary_input,  
    output [4:0] twos_output  
);  
    assign twos_output = ~binary_input + 1;  
endmodule
module phase_detector (  
    input wire A,  
    input wire B,  
    output wire in_phase  
);  
    assign in_phase = ~(A ^ B); // XOR to check phase  
endmodule
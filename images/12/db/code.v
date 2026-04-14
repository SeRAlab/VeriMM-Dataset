module audio_mux(  
    input wire [15:0] A,  // Audio input A  
    input wire [15:0] B,  // Audio input B  
    input wire S,         // Select signal  
    output wire [15:0] Y  // Output audio signal  
);  
    assign Y = S ? B : A;  
endmodule
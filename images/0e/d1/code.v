module hazard_detector (  
    input wire A,  
    input wire B,  
    input wire C,  
    output wire hazard_detected  
);  
    assign hazard_detected = (A & B) | (B & C) | (C & A);  
endmodule
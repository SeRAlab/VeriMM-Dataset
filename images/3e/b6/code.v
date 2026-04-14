module hazard_detection(A, B, Z);  
    input A, B;  
    output Z;  
    wire A_bar, B_bar, Z_temp;  
  
    // Hazard detection logic  
    assign A_bar = ~A;  
    assign B_bar = ~B;  
    assign Z_temp = A & B;  
    assign Z = Z_temp | (A_bar & B_bar); // Resolving hazards  
endmodule
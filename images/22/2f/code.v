module hazard_detection_and(input a, input b, input c, output y);  
  wire ab, ac, bc;  
  assign ab = a & b;  
  assign ac = a & c;  
  assign bc = b & c;  
  assign y = ab & c | a & bc | ab & c;  // Resolving hazards  
endmodule
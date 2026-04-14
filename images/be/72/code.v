module top_module(A, B, Ci, S, Co);input A, B, Ci;
  output S, Co;

  wire n1, n2, n3, n4;

  // XOR A and B to get the initial sum
  assign n1 = A ^ B;  // Using assign for XOR operation
  
  // XOR sum with carry in to get the intermediate sum
  assign n2 = n1 ^ Ci;  // Using assign for XOR operation
  
  // AND A and B to get the carry out from the first bit
  assign n3 = A & B;  // Using assign for AND operation
  
  // AND sum and carry in to get the carry out from the second bit
  assign n4 = n1 & Ci;  // Using assign for AND operation
  
  // OR the two carry out bits to get the final carry out
  assign Co = n3 | n4;  // Using assign for OR operation
  
  // Final sum is just the intermediate sum without carry out dependency
  assign S = n2;  // Using assign for final sum assignment
  
endmodule
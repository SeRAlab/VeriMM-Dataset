module hamming_encoder (  
    input [11:0] data_in,  
    output [15:0] codeword  
);  
    // Internal wires for parity bits  
    wire p1, p2, p3, p4;  
    wire [11:0] d;  
  
    assign d = data_in;  
  
    // Calculate parity bits  
    assign p1 = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[6] ^ d[8] ^ d[10];  
    assign p2 = d[0] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[9] ^ d[10];  
    assign p3 = d[1] ^ d[2] ^ d[3] ^ d[7] ^ d[8] ^ d[9] ^ d[10];  
    assign p4 = d[4] ^ d[5] ^ d[6] ^ d[7] ^ d[8] ^ d[9] ^ d[10];  
  
    // Assign codeword with data bits and parity bits  
    assign codeword = {p4, p3, p2, p1, d[11:0]};  
endmodule
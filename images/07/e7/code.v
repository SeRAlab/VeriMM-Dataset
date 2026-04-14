module sha256_partial_hash(input [31:0] data, output [7:0] hash_output);  
    // Example combinational logic for partial SHA-256 output  
    wire [31:0] intermediate_hash;  
    assign intermediate_hash = data ^ 32'hA5A5A5A5;  // A simple transformation for demonstration  
    assign hash_output = intermediate_hash[7:0]; // Take the first 8 bits as output  
endmodule
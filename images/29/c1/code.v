module des_single_round(  
    input wire [63:0] data_in,  
    input wire [55:0] key,  
    output reg [63:0] data_out  
);  
    // Internal registers and wires  
    wire [31:0] left, right;  
    wire [47:0] expanded_right;  
    wire [31:0] sbox_output;  
    wire [31:0] permuted_output;  
      
    // Initial Permutation (IP)  
    assign left = data_in[63:32];  
    assign right = data_in[31:0];  
      
    // Expansion  
    assign expanded_right = {right[31:26], right[31:24], right[23:20], right[19:16], right[15:12], right[11:8]}; // Simple example expansion  

    // S-box substitution (example with dummy box)  
    assign sbox_output = expanded_right ^ key[47:16]; // Simple XOR for substitution  
      
    // Permutation (P)  
    assign permuted_output = {sbox_output[31:24], sbox_output[23:16], sbox_output[15:8], sbox_output[7:0]}; // Dummy permutation  

    // Final output  
    always @(*) begin  
        data_out = {left, permuted_output}; // Combine left half and processed right half  
    end  
endmodule
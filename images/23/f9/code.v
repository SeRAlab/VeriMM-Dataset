module des_round_function(  
    input [31:0] data_in,  
    input [47:0] key,  
    output reg [31:0] data_out  
);  
    wire [47:0] expanded_data;  
    wire [47:0] xor_result;  
    wire [31:0] substituted_data;  
    wire [31:0] permuted_data;  

    // Step 1: Expansion (32-bit to 48-bit)  
    assign expanded_data = {data_in[31:24], data_in[31:24], data_in[23:16], data_in[23:16],  
                            data_in[15:8], data_in[15:8], data_in[7:0], data_in[7:0]};  

    // Step 2: Key Mixing (XOR with key)  
    assign xor_result = expanded_data ^ key;  

    // Step 3: S-box Substitution (placeholder for actual S-boxes)  
    // For simplicity, assume a direct mapping (identity)  
    assign substituted_data = xor_result[31:0];  

    // Step 4: Permutation (placeholder for actual permutation)  
    assign permuted_data = {substituted_data[31:24], substituted_data[15:8],  
                            substituted_data[23:16], substituted_data[7:0]};  

    always @(*) begin  
        data_out = permuted_data;  
    end  
endmodule
module des_single_round (input [7:0] data_in, input [7:0] key, output reg [7:0] data_out);  
    wire [7:0] permuted_data;  
    wire [7:0] expanded_data;  
    wire [7:0] substituted_data;  
    wire [7:0] final_permutation;  

    // Initial Permutation (IP)  
    assign permuted_data = {data_in[1], data_in[5], data_in[2], data_in[0], data_in[3], data_in[7], data_in[4], data_in[6]};  

    // Expansion (example operation, not real DES)  
    assign expanded_data = {permuted_data[7:4], permuted_data[1:0], permuted_data[3:2]};  

    // Substitution (example operation, not real DES)  
    assign substituted_data = expanded_data ^ key;  

    // Final Permutation (FP)  
    always @(*) begin  
        data_out = {substituted_data[3], substituted_data[0], substituted_data[5], substituted_data[2], substituted_data[7], substituted_data[4], substituted_data[1], substituted_data[6]};  
    end  
endmodule
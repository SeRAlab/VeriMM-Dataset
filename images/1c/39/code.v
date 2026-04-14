module simple_DES(  
    input [63:0] data_in,  
    input [63:0] key,  
    output reg [63:0] data_out  
);  
    // Simplified DES logic (not implementing the full DES algorithm)  
    // Just a placeholder for the initial permutation, expansion, etc.  
    always @(*) begin  
        // Initial permutation (example, not real DES)  
        data_out = {data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7],  
                    data_in[8], data_in[9], data_in[10], data_in[11], data_in[12], data_in[13], data_in[14], data_in[15]};  
        // Key mixing and substitution are omitted for simplicity  
    end  
endmodule
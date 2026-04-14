module des_round(input [63:0] data_in,  
                  input [63:0] key,  
                  output reg [63:0] data_out);  
                  
    // A fixed function to simulate the DES round operation  
    function [63:0] des_function;  
        input [63:0] data;  
        input [63:0] k;  
        begin  
            des_function = data ^ k; // Simple XOR for demonstration  
        end  
    endfunction  
      
    always @(data_in or key) begin  
        data_out = des_function(data_in, key);  
    end  
endmodule
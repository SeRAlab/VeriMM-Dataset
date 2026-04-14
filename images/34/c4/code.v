module simple_DES(  
    input [7:0] data_in,  
    input [2:0] key,  
    input clk,  
    input rst,  
    output reg [7:0] data_out  
);  

// Initial permutation table  
reg [7:0] permuted_data;  
wire [7:0] output_permutation = {permuted_data[1], permuted_data[5], permuted_data[2], permuted_data[0],  
                                  permuted_data[6], permuted_data[3], permuted_data[7], permuted_data[4]};  

// Function to combine data with key  
function [7:0] combine;  
    input [7:0] data;  
    input [2:0] k;  
    begin  
        combine = data ^ {k, 5'b00000};  // Simple XOR with key  
    end  
endfunction  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        data_out <= 8'b0;  
    end else begin  
        permuted_data <= output_permutation;  
        data_out <= combine(permuted_data, key);  
    end  
end  
endmodule
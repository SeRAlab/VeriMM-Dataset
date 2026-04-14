module des_encryption (  
    input wire clk,  
    input wire reset,  
    input wire [63:0] data_in,  
    output reg [63:0] data_out  
);  

// Initial Permutation Table  
reg [63:0] ip_table = 64'hB0B0B0B0B0B0B0B0; // Example placeholder - fill with actual IP values  
// Final Permutation Table  
reg [63:0] fp_table = 64'hD0D0D0D0D0D0D0D0; // Example placeholder - fill with actual FP values  

reg [63:0] permuted_data;  

// Initial permutation operation  
always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_out <= 64'b0;  
    end else begin  
        permuted_data <= data_in ^ ip_table; // Applying initial permutation  
        data_out <= permuted_data ^ fp_table; // Applying final permutation  
    end  
end  

endmodule
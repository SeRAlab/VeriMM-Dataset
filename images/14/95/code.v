module DES_Encryption (  
    input wire [63:0] data_in,  
    input wire [63:0] key_in,  
    output reg [63:0] data_out,  
    input wire clk,  
    input wire rst  
);  

// Internal signals for key schedule and permutation  
reg [63:0] key [0:15];  
reg [63:0] temp_data;  

// Key Schedule (simplified version)  
integer i;  
always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        for (i = 0; i < 16; i = i + 1)  
            key[i] <= 0;  
    end else begin  
        key[0] <= key_in;  
        for (i = 1; i < 16; i = i + 1)  
            key[i] <= {key[i-1][62:0], key[i-1][63]}; // Rotate key (simplification)  
    end  
end  

// Initial permutation and encryption (simplified)  
always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        data_out <= 0;  
    end else begin  
        temp_data <= data_in;  
        // Simple encryption step (for demonstration)  
        temp_data <= temp_data ^ key[0];  
        data_out <= temp_data;  
    end  
end  

endmodule
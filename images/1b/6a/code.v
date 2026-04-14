module aes_8bit (  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    input wire clk,  
    input wire rst,  
    output reg [7:0] data_out  
);  
  
// S-box for AES  
reg [7:0] sbox [0:255];  
  
initial begin  
    // Initialize S-box with example values  
    sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; sbox[8'h02] = 8'h77; sbox[8'h03] = 8'h7b;  
    sbox[8'h04] = 8'hf2; sbox[8'h05] = 8'h6b; sbox[8'h06] = 8'h6f; sbox[8'h07] = 8'hc5;  
    // Populate the rest of the S-box here  
    sbox[8'hff] = 8'h00; // Example value  
end  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        data_out <= 8'h00;  
    end else begin  
        data_out <= sbox[data_in ^ key]; // Simple AES operation  
    end  
end  
endmodule
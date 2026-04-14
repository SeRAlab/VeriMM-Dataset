module aes_sbox (  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    input clk,  
    input reset  
);  
    reg [7:0] sbox [0:255];  

    initial begin  
        // Define the S-Box values  
        sbox[0] = 8'h63; sbox[1] = 8'h7c; sbox[2] = 8'h77; sbox[3] = 8'h7b;  
        sbox[4] = 8'hf2; sbox[5] = 8'h6b; sbox[6] = 8'h6f; sbox[7] = 8'hc5;  
        sbox[8] = 8'h30; sbox[9] = 8'h01; sbox[10] = 8'h67; sbox[11] = 8'h2b;  
        sbox[12] = 8'hfe; sbox[13] = 8'hd7; sbox[14] = 8'hab; sbox[15] = 8'h76;  
        // ... (complete the S-Box initialization with all 256 entries)  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 8'h00;  
        else  
            data_out <= sbox[data_in];  
    end  
endmodule
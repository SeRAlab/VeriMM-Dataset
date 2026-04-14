module AES_SubBytes (  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  

    // S-box for substitution  
    reg [7:0] sbox [0:255];  

    initial begin  
        // Initialize the S-box (substitution box values for AES)  
        sbox[8'h00] = 8'h63;  
        sbox[8'h01] = 8'h7c;  
        sbox[8'h02] = 8'h77;  
        sbox[8'h03] = 8'h7b;  
        sbox[8'h04] = 8'hf2;  
        sbox[8'h05] = 8'h6b;  
        sbox[8'h06] = 8'h6f;  
        sbox[8'h07] = 8'hc5;  
        sbox[8'h08] = 8'h30;  
        sbox[8'h09] = 8'h01;  
        sbox[8'h0A] = 8'h67;  
        sbox[8'h0B] = 8'h2b;  
        sbox[8'h0C] = 8'hfe;  
        sbox[8'h0D] = 8'hd7;  
        sbox[8'h0E] = 8'hab;  
        sbox[8'h0F] = 8'h76;  
        // ... (rest of S-box initialization omitted for brevity)  
        sbox[8'hF0] = 8'hcc;  
        sbox[8'hF1] = 8'h10;  
        sbox[8'hF2] = 8'hf2;  
        sbox[8'hF3] = 8'hfb;  
        sbox[8'hF4] = 8'h0b;  
        sbox[8'hF5] = 8'h3c;  
        sbox[8'hF6] = 8'hc0;  
        sbox[8'hF7] = 8'hb9;  
        sbox[8'hF8] = 8'h61;  
        sbox[8'hF9] = 8'h0f;  
        sbox[8'hFA] = 8'hd6;  
        sbox[8'hFB] = 8'h99;  
        sbox[8'hFC] = 8'h0e;  
        sbox[8'hFD] = 8'h4c;  
        sbox[8'hFE] = 8'h5c;  
        sbox[8'hFF] = 8'h49;  
    end  

    always @(*) begin  
        data_out = sbox[data_in];  
    end  
endmodule
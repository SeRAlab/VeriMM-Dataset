module aes_sbox_lookup(  
    input clk,  
    input [3:0] input_data,  
    output reg [3:0] output_data  
);  
    reg [3:0] state;  

    // Predefined S-box mapping for 4-bit values  
    reg [3:0] sbox [0:15];  

    initial begin  
        sbox[0] = 4'hA;  
        sbox[1] = 4'h5;  
        sbox[2] = 4'hC;  
        sbox[3] = 4'h3;  
        sbox[4] = 4'hE;  
        sbox[5] = 4'hF;  
        sbox[6] = 4'h1;  
        sbox[7] = 4'h2;  
        sbox[8] = 4'h9;  
        sbox[9] = 4'h8;  
        sbox[10] = 4'h6;  
        sbox[11] = 4'h7;  
        sbox[12] = 4'hB;  
        sbox[13] = 4'h0;  
        sbox[14] = 4'hD;  
        sbox[15] = 4'h4;  
    end  

    always @(posedge clk) begin  
        state <= input_data;  
        output_data <= sbox[state];  
    end  
endmodule
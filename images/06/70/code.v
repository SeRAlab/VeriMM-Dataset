module aes_sbox (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] sbox [0:15]; // S-box lookup table  

    initial begin  
        sbox[0] = 4'hC;  
        sbox[1] = 4'h1;  
        sbox[2] = 4'hA;  
        sbox[3] = 4'h4;  
        sbox[4] = 4'h2;  
        sbox[5] = 4'hD;  
        sbox[6] = 4'hF;  
        sbox[7] = 4'hB;  
        sbox[8] = 4'hE;  
        sbox[9] = 4'h8;  
        sbox[10] = 4'h3;  
        sbox[11] = 4'h6;  
        sbox[12] = 4'h5;  
        sbox[13] = 4'h0;  
        sbox[14] = 4'h7;  
        sbox[15] = 4'h9;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 4'b0000;  
        end else begin  
            data_out <= sbox[data_in];  
        end  
    end  
endmodule
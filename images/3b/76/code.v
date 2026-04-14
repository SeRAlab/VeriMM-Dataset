module aes_sbox (  
    input wire [7:0] in_data,  
    output reg [7:0] out_data,  
    input wire clk,  
    input wire reset  
);  
    // AES S-box transformation array  
    reg [7:0] sbox [0:255];  

    initial begin  
        // Initialize S-box values (example values, should be filled with the correct AES S-box values)  
        sbox[8'h00] = 8'h63;  
        sbox[8'h01] = 8'h7c;  
        sbox[8'h02] = 8'h77;  
        // ... initialize all other values ...  
        sbox[8'hfe] = 8'h0b;  
        sbox[8'hff] = 8'h16;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out_data <= 8'h00;  
        else  
            out_data <= sbox[in_data];  
    end  
endmodule
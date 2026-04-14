module aes_sbox (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] sbox [0:255];  
   
    initial begin  
        // Initialize the S-Box values (truncated for brevity)  
        sbox[8'h00] = 8'h63;  
        sbox[8'h01] = 8'h7c;  
        // ... remaining S-Box initialization values  
        sbox[8'hff] = 8'h16;  
    end  
   
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 8'h00;  
        else  
            data_out <= sbox[data_in];  
    end  
endmodule
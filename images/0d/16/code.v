module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] data_in,  
    input wire [7:0] key_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] state;  
    reg [7:0] key;  
    integer i;  

    // Simple encryption logic (for illustration purposes)  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            key <= 8'b0;  
            data_out <= 8'b0;  
        end else begin  
            state <= data_in;  
            key <= key_in;  
            // Simple round transformation (just XOR for this example)  
            for (i = 0; i < 8; i = i + 1) begin  
                state[i] <= state[i] ^ key[i];  
            end  
            data_out <= state;  
        end  
    end  
endmodule
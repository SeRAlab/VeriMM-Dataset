module des_single_round(  
    input wire [7:0] data_in,  
    input wire [7:0] key,  
    output reg [7:0] data_out,  
    input wire clk,  
    input wire rst  
);  
    reg [7:0] xor_result;  
    reg [7:0] sbox_output;  
  
    // Simple XOR operation for the first step of DES  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data_out <= 8'b0;  
        end else begin  
            xor_result <= data_in ^ key;  
            // Simple substitution step (using a predefined S-box)  
            sbox_output <= {xor_result[7:6], xor_result[5:4] ^ 2'b11, xor_result[3:0]};  
            data_out <= sbox_output;  
        end  
    end  
endmodule
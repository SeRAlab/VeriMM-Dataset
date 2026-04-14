module aes_encrypt(clk, rst, data_in, key, data_out, valid);  
    input clk;  
    input rst;  
    input [7:0] data_in;  
    input [7:0] key;  
    output reg [7:0] data_out;  
    output reg valid;  

    reg [7:0] state;  
    reg [3:0] round;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            data_out <= 8'b0;  
            valid <= 1'b0;  
            round <= 4'b0;  
        end else begin  
            if (round < 4'b1000) begin  
                // Simple substitution (XOR with key)  
                state <= state ^ key;  
                // Simple permutation (rotate left)  
                state <= {state[6:0], state[7]};  
                round <= round + 1;  
            end  
            data_out <= state;  
            valid <= (round == 4'b0111);  
        end  
    end  
endmodule
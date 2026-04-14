module aes_round(input clk,  
                  input reset,  
                  input [127:0] data_in,  
                  input [127:0] key_in,  
                  output reg [127:0] data_out);  

    reg [127:0] state;  
    reg [127:0] round_key;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 128'b0;  
            round_key <= 128'b0;  
        end else begin  
            // AddRoundKey step  
            state <= data_in ^ key_in;  
            round_key <= key_in;  // In a full implementation, this would be expanded for each round  
            data_out <= state;  
        end  
    end  
endmodule
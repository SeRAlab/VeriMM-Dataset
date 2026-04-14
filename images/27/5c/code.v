module simple_des(input clk,  
                  input [7:0] plaintext,  
                  input [7:0] key,  
                  output reg [7:0] ciphertext);  
  
    reg [7:0] round_output;  
  
    always @(posedge clk) begin  
        round_output <= (plaintext ^ key) << 1;  
        ciphertext <= round_output;  
    end  
endmodule
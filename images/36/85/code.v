module chacha20_keystream_generator(  
    input clk,  
    input reset,  
    input [31:0] key,  
    input [31:0] nonce,  
    output reg [7:0] keystream  
);  
    reg [31:0] state;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 32'h00000000;  
            keystream <= 8'h00;  
        end else begin  
            state <= key ^ (state + nonce);  
            keystream <= state[7:0];  
        end  
    end  
endmodule
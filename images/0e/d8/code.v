module chacha20_round (  
    input wire clk,  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    output reg [31:0] output_data  
);  
    reg [31:0] state1;  
    reg [31:0] state2;  

    always @(posedge clk) begin  
        state1 <= state1 + key;  
        state2 <= state2 ^ nonce;  
        output_data <= state1 ^ state2;  
    end  
endmodule
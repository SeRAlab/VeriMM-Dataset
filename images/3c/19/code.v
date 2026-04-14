module chacha20_simple (  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    output reg [31:0] out_stream  
);  
    reg [31:0] state;  

    always @(key or nonce) begin  
        // Simplified transformation  
        state = key ^ nonce;  
        out_stream = {state[15:0], state[31:16]} ^ (state << 5);  
    end  
endmodule
module aes_round_function(  
    input [127:0] state,  
    input [127:0] round_key,  
    output reg [127:0] encrypted_state  
);  
    always @(state or round_key) begin  
        encrypted_state = state ^ round_key; // Simple AddRoundKey operation  
    end  
endmodule
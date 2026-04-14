module rnn_cell (  
    input [3:0] input_data,  
    input [3:0] hidden_state,  
    output reg [3:0] new_hidden_state  
);  
    // Fixed weights for W and U  
    reg [3:0] W = 4'b1010; // Example weight for input  
    reg [3:0] U = 4'b0101; // Example weight for hidden_state  

    always @(input_data or hidden_state) begin  
        // RNN update rule with simple XOR for activation function  
        new_hidden_state = (W & input_data) ^ (U & hidden_state);  
    end  
endmodule
module rnn_cell (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] input_val,  
    input wire [7:0] hidden_state_prev,  
    output reg [7:0] hidden_state_next  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hidden_state_next <= 8'b0;  
        end else begin  
            // Simple RNN update with ReLU activation  
            hidden_state_next <= (input_val + hidden_state_prev) > 8'b0 ? (input_val + hidden_state_prev) : 8'b0;  
        end  
    end  
endmodule
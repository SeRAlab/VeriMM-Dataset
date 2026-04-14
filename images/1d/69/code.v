module simple_rnn(clk, rst, input_data, hidden_state, output_data);  
    input clk;  
    input rst;  
    input [3:0] input_data;  
    input [3:0] hidden_state;  
    output reg [3:0] output_data;  

    // Simple weight initialization (for simplicity, we use fixed weights)
    parameter [3:0] W_input = 4'b0001; // Weight for input
    parameter [3:0] W_hidden = 4'b0010; // Weight for hidden state

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_data <= 4'b0000;  
        end else begin  
            // RNN update: output = ReLU(W_input * input_data + W_hidden * hidden_state)  
            output_data <= (W_input * input_data + W_hidden * hidden_state) > 4'b0000 ?  
                           (W_input * input_data + W_hidden * hidden_state) : 4'b0000;  
        end  
    end  
endmodule
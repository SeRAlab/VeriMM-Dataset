module rnn_cell(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] input_data,  
    input wire [7:0] hidden_state_prev,  
    output reg [7:0] hidden_state_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            hidden_state_out <= 8'b0;  
        end else begin  
            hidden_state_out <= $signed(hidden_state_prev) + $signed(input_data);  
            hidden_state_out <= (hidden_state_out > 127) ? 127 : ((hidden_state_out < -128) ? -128 : hidden_state_out); // Simple tanh approximation  
        end  
    end  
endmodule
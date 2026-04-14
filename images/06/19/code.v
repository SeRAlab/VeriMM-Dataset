module rnn_cell (  
    input clk,  
    input [1:0] input_data,  
    input [1:0] hidden_state,  
    output reg [1:0] output_data,  
    output reg [1:0] new_hidden_state  
);  
    always @(posedge clk) begin  
        output_data <= (input_data + hidden_state) % 4;  
        new_hidden_state <= output_data;  
    end  
endmodule
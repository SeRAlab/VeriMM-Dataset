module simple_rnn_cell (  
    input wire clk,  
    input wire rst,  
    input wire [4:0] input_vector,  
    input wire [4:0] hidden_state,  
    output reg [4:0] output_vector  
);  
    reg [4:0] new_hidden_state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            new_hidden_state <= 5'b0;  
            output_vector <= 5'b0;  
        end else begin  
            new_hidden_state <= input_vector + hidden_state;  
            output_vector <= new_hidden_state;  
        end  
    end  
endmodule
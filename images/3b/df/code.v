module rnn_cell(  
    input clk,  
    input [3:0] input_data,  
    output reg [3:0] output_data  
);  
    reg [3:0] hidden_state;  

    always @(posedge clk) begin  
        hidden_state <= (hidden_state + input_data) % 16;  
        output_data <= hidden_state;  
    end  
endmodule
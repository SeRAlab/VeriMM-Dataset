module rnn_unit (  
    input clk,  
    input rst_n,  
    input [7:0] x_in,  
    output reg [7:0] y_out  
);  
    reg [7:0] hidden_state;  
      
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            hidden_state <= 8'b0;  
            y_out <= 8'b0;  
        end else begin  
            hidden_state <= hidden_state + x_in;  
            y_out <= hidden_state;  
        end  
    end  
endmodule
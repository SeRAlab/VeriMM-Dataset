module gradient_descent (  
    input wire clk,  
    input wire reset,  
    input wire signed [15:0] current_position,  
    input wire signed [15:0] learning_rate,  
    output reg signed [15:0] updated_position  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_position <= 0;  
        end else begin  
            updated_position <= current_position - learning_rate;  
        end  
    end  
endmodule
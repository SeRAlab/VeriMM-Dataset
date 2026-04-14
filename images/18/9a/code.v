module gradient_descent(  
    input wire clk,  
    input wire reset,  
    input wire [31:0] current_weight,  
    input wire [31:0] input_data,  
    input wire [31:0] learning_rate,  
    output reg [31:0] new_weight  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_weight <= 32'b0;  
        end else begin  
            new_weight <= current_weight - (learning_rate * (input_data - current_weight));  
        end  
    end  
endmodule
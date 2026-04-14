module gradient_descent_optimizer #(parameter WIDTH = 16) (  
    input clk,  
    input reset,  
    input [WIDTH-1:0] current_param,  
    input [WIDTH-1:0] gradient,  
    input [WIDTH-1:0] learning_rate,  
    output reg [WIDTH-1:0] updated_param  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            updated_param <= 0;  
        else  
            updated_param <= current_param - (gradient * learning_rate);  
    end  
endmodule
module gradient_descent (  
    input [15:0] current_param,  
    input [15:0] gradient,  
    input [15:0] learning_rate,  
    output reg [15:0] updated_param  
);  
    always @(*) begin  
        updated_param = current_param - (gradient * learning_rate);  
    end  
endmodule
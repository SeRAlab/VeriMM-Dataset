module gradient_descent(  
    input wire clk,  
    input wire enable,  
    input wire [15:0] weights_old,  
    input wire [15:0] gradient,  
    input wire [7:0] learning_rate,  
    output reg [15:0] weights_new  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            weights_new <= weights_old - ((learning_rate * gradient) >> 8);  
        end  
    end  
endmodule
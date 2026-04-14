module gradient_descent #(parameter DATA_WIDTH = 16, parameter LEARNING_RATE = 1) (  
    input clk,  
    input reset,  
    input [DATA_WIDTH-1:0] initial_x,  
    input [3:0] iterations,  
    output reg [DATA_WIDTH-1:0] updated_x  
);  

    reg [DATA_WIDTH-1:0] x;  
    reg [3:0] count;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            x <= initial_x;  
            updated_x <= initial_x;  
            count <= 0;  
        end else if (count < iterations) begin  
            x <= x - (LEARNING_RATE * x);  
            updated_x <= x;  
            count <= count + 1;  
        end  
    end  
endmodule
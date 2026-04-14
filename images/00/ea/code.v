module stack #(parameter DEPTH = 8, parameter WIDTH = 8) (  
    input wire clk,  
    input wire rst,  
    input wire [WIDTH-1:0] data_in,  
    input wire push,  
    input wire pop,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty  
);  
    reg [WIDTH-1:0] stack_mem [0:DEPTH-1];  
    reg [3:0] top;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            empty <= 1;  
        end else begin  
            if (push && top < DEPTH) begin  
                stack_mem[top] <= data_in;  
                top <= top + 1;  
                empty <= 0;  
            end  
            if (pop && top > 0) begin  
                top <= top - 1;  
                data_out <= stack_mem[top];  
                if (top == 1)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule
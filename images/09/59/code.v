module stack #(parameter DEPTH = 8) (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] stack_mem [0:DEPTH-1];  
    reg [3:0] top; // points to the top of the stack  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (push && !full) begin  
                stack_mem[top] <= data_in;  
                top <= top + 1;  
            end  
            if (pop && !empty) begin  
                top <= top - 1;  
                data_out <= stack_mem[top];  
            end  
            full <= (top == DEPTH);  
            empty <= (top == 0);  
        end  
    end  
endmodule
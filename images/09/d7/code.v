module LIFO_Stack (  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [7:0] stack_mem [3:0];  
    reg [1:0] stack_pointer;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stack_pointer <= 2'b00;  
            full <= 1'b0;  
            empty <= 1'b1;  
            data_out <= 8'b0;  
        end else begin  
            if (push && !full) begin  
                stack_mem[stack_pointer] <= data_in;  
                stack_pointer <= stack_pointer + 1;  
            end  
            if (pop && !empty) begin  
                stack_pointer <= stack_pointer - 1;  
                data_out <= stack_mem[stack_pointer - 1];  
            end  
            full <= (stack_pointer == 2'b11);  
            empty <= (stack_pointer == 2'b00);  
        end  
    end  
endmodule
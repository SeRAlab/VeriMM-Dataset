module LIFO_Stack(  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    input push,  
    input pop,  
    output reg [3:0] data_out,  
    output reg empty  
);  
    reg [3:0] stack [0:15];  
    reg [3:0] top;  

    initial begin  
        top = 4'b0000;  
        empty = 1;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            top <= 4'b0000;  
            empty <= 1;  
        end else begin  
            if (push) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= 0;  
            end  
            if (pop && top > 0) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                if (top == 1)  
                    empty <= 1;  
            end  
        end  
    end  
endmodule
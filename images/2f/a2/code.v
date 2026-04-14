module LIFO_Stack(  
    input clk,  
    input reset,  
    input push_en,  
    input pop_en,  
    input [3:0] data_in,  
    output reg [3:0] data_out,  
    output reg empty  
);  
    reg [3:0] stack [3:0];  
    reg [1:0] top;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            top <= 0;  
            data_out <= 0;  
            empty <= 1;  
        end else begin  
            if (push_en && top < 4) begin  
                stack[top] <= data_in;  
                top <= top + 1;  
                empty <= (top + 1 == 0);  
            end  
            if (pop_en && top > 0) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                empty <= (top - 1 == 0);  
            end  
        end  
    end  
endmodule
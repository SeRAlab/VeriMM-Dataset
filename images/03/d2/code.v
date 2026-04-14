module LIFO_Stack(  
    input clk,  
    input rst,  
    input push,  
    input pop,  
    input [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg full  
);  
    reg [7:0] stack [7:0];  
    reg [2:0] top;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            top <= 3'b000;  
            full <= 1'b0;  
        end else begin  
            if (push && !full) begin  
                stack[top] <= data_in;  
                if (top == 3'b111) begin  
                    full <= 1'b1;  
                end  
                top <= top + 1;  
            end  
            if (pop && top > 3'b000) begin  
                top <= top - 1;  
                data_out <= stack[top];  
                full <= 1'b0;  
            end  
        end  
    end  
endmodule
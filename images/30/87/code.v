module non_restoring_divider #(parameter WIDTH=8) (  
    input [WIDTH-1:0] A,  
    input [WIDTH-1:0] B,  
    input start,  
    input clk,  
    input reset,  
    output reg [WIDTH-1:0] Q,  
    output reg [WIDTH-1:0] R,  
    output reg done  
);  
    reg [WIDTH-1:0] a;  
    reg [WIDTH-1:0] b;  
    reg [WIDTH:0] temp;  
    reg [3:0] count;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            Q <= 0;  
            R <= 0;  
            done <= 0;  
            count <= 0;  
        end else if (start) begin  
            a <= A;  
            b <= B;  
            temp <= 0;  
            Q <= 0;  
            R <= A;  
            count <= WIDTH;  
            done <= 0;  
        end else if (count > 0) begin  
            temp = {R[WIDTH-1:1], 1'b0} - b;  
            if (temp[WIDTH] == 0) begin  
                R <= temp[WIDTH-1:0];  
                Q <= {Q[WIDTH-2:0], 1'b1};  
            end else begin  
                R <= {R[WIDTH-1:1], 1'b0};  
                Q <= {Q[WIDTH-2:0], 1'b0};  
            end  
            count <= count - 1;  
            if (count == 1) begin  
                done <= 1;  
            end  
        end  
    end  
endmodule
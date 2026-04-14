module bst_insert (  
    input clk,  
    input [7:0] value,  
    output reg [7:0] root,  
    output reg success  
);  
    reg [7:0] left, right;  
    initial begin  
        root = 0;  
        left = 0;  
        right = 0;  
        success = 0;  
    end  

    always @(posedge clk) begin  
        if (root == 0) begin  
            root <= value;  
            success <= 1;  
        end else if (value < root) begin  
            if (left == 0) begin  
                left <= value;  
                success <= 1;  
            end else begin  
                success <= 0;  
            end  
        end else if (value > root) begin  
            if (right == 0) begin  
                right <= value;  
                success <= 1;  
            end else begin  
                success <= 0;  
            end  
        end else begin  
            success <= 0; // Duplicate value not inserted  
        end  
    end  
endmodule
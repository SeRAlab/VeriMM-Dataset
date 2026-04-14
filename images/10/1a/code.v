module rrt_expansion(input [7:0] current_x,  
                     input [7:0] current_y,  
                     input [7:0] step_size,  
                     input [7:0] boundary_x,  
                     input [7:0] boundary_y,  
                     output reg [7:0] new_x,  
                     output reg [7:0] new_y);  
                     
    always @(*) begin  
        new_x = current_x + step_size;  
        new_y = current_y + step_size;  
        
        if (new_x > boundary_x) begin  
            new_x = boundary_x;  
        end  
        
        if (new_y > boundary_y) begin  
            new_y = boundary_y;  
        end  
    end  
endmodule
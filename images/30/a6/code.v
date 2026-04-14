module rrt_controller (  
    input clk,  
    input reset,  
    input start,  
    input condition,  
    output reg new_node  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_node <= 0;  
        end else if (start && condition) begin  
            new_node <= 1;  
        end else begin  
            new_node <= 0;  
        end  
    end  
endmodule
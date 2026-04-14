module linked_list_traversal(  
    input clk,  
    input reset,  
    input [7:0] current_data,  
    input [15:0] current_next,  
    output reg [7:0] output_data,  
    output reg done  
);  
    reg [15:0] next_pointer;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_data <= 8'd0;  
            done <= 1'b0;  
            next_pointer <= 16'd0;  
        end else begin  
            if (next_pointer == 16'd0) begin  
                output_data <= current_data;  
                next_pointer <= current_next;  
                done <= 1'b0;  
            end else if (next_pointer != 16'd0) begin  
                output_data <= current_data;  
                next_pointer <= current_next;  
                done <= 1'b0;  
            end else begin  
                done <= 1'b1;  
            end  
        end  
    end  
endmodule
module gpio_controller (  
    input clk,  
    input rst,  
    input mode,  // 0 for input, 1 for output  
    input value, // value to set for output mode  
    output reg current_state // state of the GPIO pin  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_state <= 1'b0;  
        end else begin  
            if (mode) begin  
                // Output mode  
                current_state <= value;  
            end  
            // In input mode, current_state is not affected  
        end  
    end  
endmodule
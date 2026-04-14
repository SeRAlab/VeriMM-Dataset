module gpio_controller(  
    input wire clk,  
    input wire reset,  
    input wire set,  
    input wire clear,  
    output reg pin_state  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            pin_state <= 0;  
        end else begin  
            if (set) begin  
                pin_state <= 1;  
            end else if (clear) begin  
                pin_state <= 0;  
            end  
        end  
    end  
endmodule
module gpio_controller (  
    input wire clk,  
    input wire latch,  
    input wire update,  
    input wire [3:0] gpio_in,  
    output reg [3:0] gpio_out  
);  
    reg [3:0] latched_value;  
    
    always @(posedge clk) begin  
        if (latch) begin  
            latched_value <= gpio_in;  
        end  
        if (update) begin  
            gpio_out <= latched_value;  
        end  
    end  
endmodule
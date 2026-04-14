module gpio_controller(  
    input wire clk,  
    input wire rst,  
    input wire enable,  
    input wire [1:0] ctrl,  
    output reg [1:0] gpio_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            gpio_out <= 2'b00;  
        else if (enable) begin  
            gpio_out <= ctrl;  
        end  
    end  
endmodule
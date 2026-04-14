module gpio_controller(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] gpio_in,  
    output reg gpio_out  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        gpio_out <= 1'b0;  
    end else if (gpio_in == 4'b1111) begin  
        gpio_out <= ~gpio_out;  
    end  
end  
endmodule
module gpio_controller(  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input read_enable,  
    output reg [7:0] gpio_out  
);  
    reg [7:0] gpio_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            gpio_reg <= 8'b0;  
            gpio_out <= 8'b0;  
        end else begin  
            gpio_reg <= data_in;  
            if (read_enable) begin  
                gpio_out <= gpio_reg;  
            end  
        end  
    end  
endmodule
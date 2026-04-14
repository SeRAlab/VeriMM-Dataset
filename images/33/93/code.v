module gpio_controller (  
    input clk,  
    input rst,  
    input [3:0] data_in,  
    input read_en,  
    output reg [3:0] gpio_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            gpio_out <= 4'b0000;  
        else if (read_en)  
            gpio_out <= gpio_out;  
        else  
            gpio_out <= data_in;  
    end  
endmodule
module gpio_controller(  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    input control,  
    output reg [7:0] gpio_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            gpio_out <= 8'b00000000;  
        end else if (control) begin  
            gpio_out <= data_in;  
        end  
    end  
endmodule
module gpio_controller(  
    input clk,  
    input rst,  
    input [4:0] data_in,  
    input write_enable,  
    input read_enable,  
    output reg [4:0] data_out  
);  
    reg [4:0] gpio_pins;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            gpio_pins <= 5'b00000;  
            data_out <= 5'b00000;  
        end else begin  
            if (write_enable) begin  
                gpio_pins <= data_in;  
            end  
            if (read_enable) begin  
                data_out <= gpio_pins;  
            end  
        end  
    end  
endmodule
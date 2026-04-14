module gpio_controller(  
    input clk,  
    input rst_n,  
    input [3:0] data_in,  
    input write_enable,  
    input read_enable,  
    output reg [3:0] data_out  
);  
    reg [3:0] gpio_value;  
  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            gpio_value <= 4'b0000;  
            data_out <= 4'b0000;  
        end else begin  
            if (write_enable) begin  
                gpio_value <= data_in;  
            end  
            if (read_enable) begin  
                data_out <= gpio_value;  
            end  
        end  
    end  
endmodule
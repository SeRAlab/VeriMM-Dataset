module gpio_controller (  
    input wire clk,  
    input wire reset,  
    input wire mode, // 0 for read, 1 for write  
    input wire [7:0] gpio_data_in,  
    output reg [7:0] gpio_data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            gpio_data_out <= 8'b00000000;  
        end else begin  
            if (mode == 0) begin // read mode  
                gpio_data_out <= gpio_data_in;  
            end  
            // when mode is 1 (write), the output does not change  
        end  
    end  
endmodule
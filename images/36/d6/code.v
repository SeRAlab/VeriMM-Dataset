module gpio_controller(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] pin_num,  
    input wire rw,  
    input wire data_in,  
    output reg data_out  
);  
    reg [3:0] gpio_pins;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            gpio_pins <= 4'b0000;  
            data_out <= 1'b0;  
        end else begin  
            if (rw) begin  // Write operation  
                gpio_pins[pin_num] <= data_in;  
            end else begin  // Read operation  
                data_out <= gpio_pins[pin_num];  
            end  
        end  
    end  
endmodule
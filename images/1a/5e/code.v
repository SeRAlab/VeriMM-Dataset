module gpio_controller(  
    input wire clk,  
    input wire enable,  
    input wire [7:0] set_pins,  
    output reg [7:0] read_pins  
);  
    reg [7:0] gpio_state;  

    always @(posedge clk) begin  
        if (enable) begin  
            gpio_state <= set_pins;  
        end  
    end  

    always @(posedge clk) begin  
        read_pins <= gpio_state;  
    end  

    initial begin  
        gpio_state = 8'b00000000;  
    end  
endmodule
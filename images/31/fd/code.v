module gpio_controller(  
    input wire [4:0] gpio_in,  
    input wire set_clear,  
    input wire clk,  
    output reg [4:0] gpio_out  
);  

    always @(posedge clk) begin  
        if (set_clear) begin  
            gpio_out <= gpio_in;  
        end else begin  
            gpio_out <= 5'b00000;  
        end  
    end  
endmodule
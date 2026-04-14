module gpio_controller(input wire clk,  
                       input wire control,  
                       input wire [7:0] gpio_in,  
                       output reg [7:0] gpio_out);  

    always @(posedge clk) begin  
        if (control) begin  
            gpio_out <= gpio_in;  
        end  
    end  
endmodule
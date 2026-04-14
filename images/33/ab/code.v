module gpio_controller (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] gpio_input,  
    input wire control,  
    output reg [4:0] gpio_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            gpio_output <= 5'b00000;  
        end else begin  
            if (control) begin  
                gpio_output <= gpio_input;  
            end else begin  
                gpio_output <= 5'b00000;  
            end  
        end  
    end  
endmodule
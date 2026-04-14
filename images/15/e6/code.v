module gpio_controller (  
    input wire clk,  
    input wire reset,  
    input wire [4:0] gpio_input,  
    output reg [4:0] gpio_output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            gpio_output <= 5'b00000;  
        else  
            gpio_output <= gpio_input;  
    end  
endmodule
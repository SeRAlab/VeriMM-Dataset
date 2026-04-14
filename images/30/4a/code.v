module gpio_controller(  
    input clk,  
    input reset,  
    input [1:0] input_pins,  
    output reg [1:0] output_pins  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_pins <= 2'b00;  
        end else begin  
            output_pins <= input_pins;  
        end  
    end  
endmodule
module gpio_controller(  
    input clk,  
    input reset,  
    input [7:0] input_data,  
    output reg [7:0] output_data  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            output_data <= 8'b0;  
        else  
            output_data <= input_data;  
    end  
endmodule
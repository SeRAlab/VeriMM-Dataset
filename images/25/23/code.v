module gpio_controller (  
    input wire clk,  
    input wire enable,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] gpio_port;  
  
    always @(posedge clk) begin  
        if (enable) begin  
            gpio_port <= data_in;  
        end  
        data_out <= gpio_port;  
    end  
endmodule
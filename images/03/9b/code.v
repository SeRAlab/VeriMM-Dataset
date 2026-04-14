module gpio_controller (  
    input wire clk,  
    input wire we,  
    input wire re,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] gpio_port;  
   
    always @(posedge clk) begin  
        if (we) begin  
            gpio_port <= data_in;  
        end  
        if (re) begin  
            data_out <= gpio_port;  
        end  
    end  
endmodule
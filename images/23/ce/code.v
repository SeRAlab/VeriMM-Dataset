module vco (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] control_voltage,  
    output reg [2:0] frequency  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            frequency <= 3'b000;  
        end else begin  
            frequency <= control_voltage[2:0];  
        end  
    end  
endmodule
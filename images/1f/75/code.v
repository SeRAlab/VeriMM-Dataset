module VCO (  
    input wire clk,  
    input wire [2:0] control_voltage,  
    output reg [3:0] frequency  
);  

    reg [3:0] counter;  

    always @(posedge clk) begin  
        counter <= counter + control_voltage;  
        frequency <= counter;  
    end  
endmodule
module VCO (  
    input clk,  
    input [3:0] control_voltage,  
    output reg [7:0] frequency_out  
);  

    always @(posedge clk) begin  
        frequency_out <= control_voltage * 10; // Simple frequency scaling  
    end  
endmodule
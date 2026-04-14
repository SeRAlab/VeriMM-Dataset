module voltage_regulator (  
    input wire clk,  
    input wire enable,  
    input wire [4:0] input_voltage,  
    output reg [4:0] output_voltage  
);  

always @(posedge clk) begin  
    if (enable) begin  
        output_voltage <= input_voltage << 1; // Multiply input voltage by 2  
    end else begin  
        output_voltage <= 5'b00000; // Set output to 0V when not enabled  
    end  
end  
endmodule
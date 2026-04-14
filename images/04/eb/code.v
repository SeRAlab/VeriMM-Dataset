module DVFS_Controller(  
    input wire clk,  
    input wire enable,  
    input wire [1:0] voltage_level,  
    output reg [1:0] frequency_output  
);  

always @(posedge clk) begin  
    if (enable) begin  
        case (voltage_level)  
            2'b00: frequency_output <= 2'b00; // lowest frequency  
            2'b01: frequency_output <= 2'b01; // medium frequency  
            2'b10: frequency_output <= 2'b10; // high frequency  
            2'b11: frequency_output <= 2'b11; // maximum frequency  
            default: frequency_output <= 2'b00; // default to lowest  
        endcase  
    end else begin  
        frequency_output <= 2'b00; // when not enabled, set to lowest frequency  
    end  
end  
endmodule
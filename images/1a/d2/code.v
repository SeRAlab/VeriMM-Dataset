module dvfs_controller (  
    input wire clk,  
    input wire [2:0] load_signal,  
    output reg [1:0] voltage_setting,  
    output reg [1:0] frequency_setting  
);  

always @(posedge clk) begin  
    case(load_signal)  
        3'b000: begin  
            voltage_setting <= 2'b00; // Low voltage  
            frequency_setting <= 2'b00; // Low frequency  
        end  
        3'b001: begin  
            voltage_setting <= 2'b00;  
            frequency_setting <= 2'b01; // Medium frequency  
        end  
        3'b010: begin  
            voltage_setting <= 2'b01; // Medium voltage  
            frequency_setting <= 2'b01;  
        end  
        3'b011: begin  
            voltage_setting <= 2'b01;  
            frequency_setting <= 2'b10; // High frequency  
        end  
        3'b100: begin  
            voltage_setting <= 2'b10; // High voltage  
            frequency_setting <= 2'b10;  
        end  
        default: begin  
            voltage_setting <= 2'b00;  
            frequency_setting <= 2'b00;  
        end  
    endcase  
end  
endmodule
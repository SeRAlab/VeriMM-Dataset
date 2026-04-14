module DVFS_Controller(  
    input clk,  
    input rst,  
    input [1:0] load, // 00: low load, 01: medium load, 10: high load, 11: overload  
    output reg [1:0] voltage, // 00: low voltage, 01: medium voltage, 10: high voltage  
    output reg [1:0] frequency // 00: low freq, 01: medium freq, 10: high freq  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            voltage <= 2'b00;  
            frequency <= 2'b00;  
        end else begin  
            case (load)  
                2'b00: begin  
                    voltage <= 2'b00; // low voltage  
                    frequency <= 2'b00; // low frequency  
                end  
                2'b01: begin  
                    voltage <= 2'b01; // medium voltage  
                    frequency <= 2'b01; // medium frequency  
                end  
                2'b10: begin  
                    voltage <= 2'b10; // high voltage  
                    frequency <= 2'b10; // high frequency  
                end  
                2'b11: begin  
                    voltage <= 2'b10; // maximum voltage  
                    frequency <= 2'b10; // maximum frequency  
                end  
                default: begin  
                    voltage <= 2'b00;  
                    frequency <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule
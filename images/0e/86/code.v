module DVFS_Controller (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] workload,  
    output reg [1:0] voltage,  
    output reg [1:0] frequency  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            voltage <= 2'b00;  
            frequency <= 2'b00;  
        end else begin  
            case (workload)  
                2'b00: begin  
                    voltage <= 2'b00;  
                    frequency <= 2'b00;  
                end  
                2'b01: begin  
                    voltage <= 2'b01;  
                    frequency <= 2'b01;  
                end  
                2'b10: begin  
                    voltage <= 2'b10;  
                    frequency <= 2'b10;  
                end  
                2'b11: begin  
                    voltage <= 2'b11;  
                    frequency <= 2'b11;  
                end  
                default: begin  
                    voltage <= 2'b00;  
                    frequency <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule
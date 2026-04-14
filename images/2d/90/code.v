module DVFS_Controller(  
    input wire clk,  
    input wire rst,  
    input wire [1:0] request,  
    output reg [1:0] frequency,  
    output reg [1:0] voltage  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            frequency <= 2'b00;  
            voltage <= 2'b00;  
        end else begin  
            case (request)  
                2'b00: begin // Low  
                    frequency <= 2'b00;  
                    voltage <= 2'b00;  
                end  
                2'b01: begin // Medium  
                    frequency <= 2'b01;  
                    voltage <= 2'b01;  
                end  
                2'b10: begin // High  
                    frequency <= 2'b10;  
                    voltage <= 2'b10;  
                end  
                default: begin  
                    frequency <= 2'b00;  
                    voltage <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule
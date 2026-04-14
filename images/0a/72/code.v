module DVFS_Controller (  
    input clk,  
    input reset,  
    input [1:0] load, // 00: low, 01: medium, 10: high, 11: very high  
    output reg [2:0] frequency, // 000: low, 001: medium, 010: high, 011: very high  
    output reg [1:0] voltage // 00: low, 01: medium, 10: high  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency <= 3'b000;  
            voltage <= 2'b00;  
        end else begin  
            case (load)  
                2'b00: begin  
                    frequency <= 3'b000;  
                    voltage <= 2'b00;  
                end  
                2'b01: begin  
                    frequency <= 3'b001;  
                    voltage <= 2'b01;  
                end  
                2'b10: begin  
                    frequency <= 3'b010;  
                    voltage <= 2'b10;  
                end  
                2'b11: begin  
                    frequency <= 3'b011;  
                    voltage <= 2'b10;  
                end  
                default: begin  
                    frequency <= 3'b000;  
                    voltage <= 2'b00;  
                end  
            endcase  
        end  
    end  
endmodule
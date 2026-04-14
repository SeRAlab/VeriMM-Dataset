module dvfs_controller(  
    input clk,  
    input rst,  
    input [2:0] request,  
    output reg [1:0] voltage,  // 00: 0.5V, 01: 1.0V, 10: 1.5V, 11: 2.0V, 100: 2.5V  
    output reg [2:0] frequency  // 000: 100MHz, 001: 200MHz, 010: 300MHz, 011: 400MHz, 100: 500MHz  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            voltage <= 2'b00;  
            frequency <= 3'b000;  
        end else begin  
            case (request)  
                3'b000: begin voltage <= 2'b00; frequency <= 3'b000; end // 0.5V, 100MHz  
                3'b001: begin voltage <= 2'b01; frequency <= 3'b001; end // 1.0V, 200MHz  
                3'b010: begin voltage <= 2'b10; frequency <= 3'b010; end // 1.5V, 300MHz  
                3'b011: begin voltage <= 2'b11; frequency <= 3'b011; end // 2.0V, 400MHz  
                3'b100: begin voltage <= 3'b100; frequency <= 3'b100; end // 2.5V, 500MHz  
                default: begin voltage <= voltage; frequency <= frequency; end // hold  
            endcase  
        end  
    end  
endmodule
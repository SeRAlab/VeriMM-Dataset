module dvfs_controller(  
    input wire clk,  
    input wire [1:0] workload,  
    output reg [7:0] voltage,  
    output reg [7:0] frequency  
);  
    always @(posedge clk) begin  
        case (workload)  
            2'b00: begin  
                voltage <= 8'b00000001; // 1.0V  
                frequency <= 8'b00000001; // 1.0GHz  
            end  
            2'b01: begin  
                voltage <= 8'b00000010; // 1.2V  
                frequency <= 8'b00000011; // 1.5GHz  
            end  
            2'b10: begin  
                voltage <= 8'b00000101; // 1.5V  
                frequency <= 8'b00001000; // 2.0GHz  
            end  
            2'b11: begin  
                voltage <= 8'b00001110; // 1.8V  
                frequency <= 8'b00001101; // 2.5GHz  
            end  
            default: begin  
                voltage <= 8'b00000000;  
                frequency <= 8'b00000000;  
            end  
        endcase  
    end  
endmodule
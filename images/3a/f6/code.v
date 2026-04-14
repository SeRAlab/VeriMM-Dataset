module dvfs_controller(  
    input wire clk,  
    input wire [1:0] perf_level,  
    output reg [7:0] voltage,  
    output reg [7:0] frequency  
);  
    always @(posedge clk) begin  
        case (perf_level)  
            2'b00: begin  
                voltage <= 8'b00000001; // 1V  
                frequency <= 8'b00000001; // 1GHz  
            end  
            2'b01: begin  
                voltage <= 8'b00000010; // 1.2V  
                frequency <= 8'b00000010; // 1.2GHz  
            end  
            2'b10: begin  
                voltage <= 8'b00000011; // 1.4V  
                frequency <= 8'b00000011; // 1.5GHz  
            end  
            2'b11: begin  
                voltage <= 8'b00000100; // 1.8V  
                frequency <= 8'b00000100; // 2GHz  
            end  
        endcase  
    end  
endmodule
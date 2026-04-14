module dvfs_controller (  
    input [1:0] workload,  
    output reg [1:0] frequency,  
    output reg [1:0] voltage  
);  
    always @(*) begin  
        case (workload)  
            2'b00: begin  
                frequency = 2'b00; // 1 GHz  
                voltage = 2'b00;   // 1 V  
            end  
            2'b01: begin  
                frequency = 2'b01; // 2 GHz  
                voltage = 2'b01;   // 1.2 V  
            end  
            2'b10: begin  
                frequency = 2'b10; // 3 GHz  
                voltage = 2'b10;   // 1.5 V  
            end  
            2'b11: begin  
                frequency = 2'b11; // 4 GHz  
                voltage = 2'b11;   // 1.8 V  
            end  
            default: begin  
                frequency = 2'b00;  
                voltage = 2'b00;  
            end  
        endcase  
    end  
endmodule
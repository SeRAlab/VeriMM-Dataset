module dvfs_controller(  
    input clk,  
    input reset,  
    input [3:0] workload,  // 4-bit workload input  
    output reg [2:0] frequency, // 3-bit frequency output  
    output reg [2:0] voltage    // 3-bit voltage output  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            frequency <= 3'b000;  
            voltage <= 3'b000;  
        end else begin  
            case (workload)  
                4'b0000: begin  // Low workload  
                    frequency <= 3'b001; // 1 GHz  
                    voltage <= 3'b001;   // 1 V  
                end  
                4'b0001: begin  
                    frequency <= 3'b010; // 2 GHz  
                    voltage <= 3'b010;   // 1.2 V  
                end  
                4'b0010: begin  
                    frequency <= 3'b011; // 3 GHz  
                    voltage <= 3'b011;   // 1.5 V  
                end  
                4'b0011: begin  
                    frequency <= 3'b100; // 4 GHz  
                    voltage <= 3'b100;   // 1.8 V  
                end  
                default: begin  
                    frequency <= 3'b000;  
                    voltage <= 3'b000;  
                end  
            endcase  
        end  
    end  
endmodule
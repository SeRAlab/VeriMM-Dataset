module phase_shifter(  
    input [2:0] angle,  
    output reg [3:0] phase_output  
);  
    always @(angle) begin  
        case (angle)  
            3'b000: phase_output = 4'b0000; // 0 degrees  
            3'b001: phase_output = 4'b0010; // 45 degrees  
            3'b010: phase_output = 4'b0100; // 90 degrees  
            3'b011: phase_output = 4'b0110; // 135 degrees  
            3'b100: phase_output = 4'b1000; // 180 degrees  
            3'b101: phase_output = 4'b1010; // 225 degrees  
            3'b110: phase_output = 4'b1100; // 270 degrees  
            3'b111: phase_output = 4'b1110; // 315 degrees  
            default: phase_output = 4'b0000;  
        endcase  
    end  
endmodule
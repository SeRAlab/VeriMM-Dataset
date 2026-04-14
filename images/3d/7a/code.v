module phase_shifter(  
    input wire clk,  
    input wire reset,  
    input wire [2:0] phase_code,  
    output reg [2:0] phase_shifted  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            phase_shifted <= 3'b000;  
        end else begin  
            case (phase_code)  
                3'b000: phase_shifted <= 3'b000; // 0 degrees  
                3'b001: phase_shifted <= 3'b001; // 45 degrees  
                3'b010: phase_shifted <= 3'b010; // 90 degrees  
                3'b011: phase_shifted <= 3'b011; // 135 degrees  
                3'b100: phase_shifted <= 3'b100; // 180 degrees  
                3'b101: phase_shifted <= 3'b101; // 225 degrees  
                3'b110: phase_shifted <= 3'b110; // 270 degrees  
                3'b111: phase_shifted <= 3'b111; // 315 degrees  
                default: phase_shifted <= 3'b000;  
            endcase  
        end  
    end  
endmodule
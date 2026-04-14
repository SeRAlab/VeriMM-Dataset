module phase_shifter(  
    input wire clk,  
    input wire [1:0] phase_control,  
    output reg phase_shifted_clk  
);  
    always @(posedge clk) begin  
        case (phase_control)  
            2'b00: phase_shifted_clk <= clk;  
            2'b01: phase_shifted_clk <= ~clk;  
            2'b10: phase_shifted_clk <= clk; // 90 degrees phase shift  
            2'b11: phase_shifted_clk <= ~clk; // 180 degrees phase shift  
            default: phase_shifted_clk <= clk;  
        endcase  
    end  
endmodule
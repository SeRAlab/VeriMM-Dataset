module power_gating_control(  
    input [1:0] mode,  
    output reg gate_control  
);  
    always @(*) begin  
        case (mode)  
            2'b00: gate_control = 1'b0; // Off  
            2'b01: gate_control = 1'b1; // Idle  
            2'b10: gate_control = 1'b1; // Active  
            2'b11: gate_control = 1'b1; // Test  
            default: gate_control = 1'b0;  
        endcase  
    end  
endmodule
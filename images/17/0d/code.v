module LDO_Regulator (  
    input [3:0] v_ref, // Voltage reference input  
    input [1:0] control, // Control signal to set output voltage  
    output reg [3:0] v_out // Regulated output voltage  
);  
    always @(*) begin  
        case (control)  
            2'b00: v_out = v_ref;         // Output = Reference voltage  
            2'b01: v_out = v_ref - 1;     // Output = Reference voltage - 1  
            2'b10: v_out = v_ref - 2;     // Output = Reference voltage - 2  
            2'b11: v_out = v_ref - 3;     // Output = Reference voltage - 3  
            default: v_out = 4'b0000;      // Default case  
        endcase  
    end  
endmodule
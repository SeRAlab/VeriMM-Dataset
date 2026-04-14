module phase_shifter(  
    input [2:0] phase_in,  
    input control,  
    output reg [2:0] phase_out  
);  
    always @(*) begin  
        if (control)  
            phase_out = {phase_in[1:0], phase_in[2]}; // Shift left with wrap-around  
        else  
            phase_out = phase_in;  
    end  
endmodule
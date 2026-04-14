module phase_shifter(  
    input clk,  
    input rst,  
    input [4:0] phase_in,  
    output reg [4:0] phase_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            phase_out <= 5'b00000;  
        else  
            phase_out <= {phase_in[3:0], phase_in[4]}; // Shift left by 1  
    end  
endmodule
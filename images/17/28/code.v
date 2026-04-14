module phase_shifter(  
    input clk,  
    input reset,  
    input [2:0] phase_in,  
    output reg [2:0] phase_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            phase_out <= 3'b000;  
        else  
            phase_out <= (phase_in + 3'b001) % 8;  
    end  
endmodule
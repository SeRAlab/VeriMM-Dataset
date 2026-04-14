module phase_shifter(  
    input clk,  
    input rst,  
    input [4:0] phase_in,  
    input [2:0] shift_value,  
    output reg [4:0] phase_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            phase_out <= 5'b00000;  
        end else begin  
            phase_out <= (phase_in + shift_value) % 32;  
        end  
    end  
endmodule
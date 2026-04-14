module noise_suppression(  
    input clk,  
    input reset,  
    input signal_in,  
    output reg signal_out  
);  

    reg [2:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 3'b000;  
            signal_out <= 1'b0;  
        end else begin  
            shift_reg <= {shift_reg[1:0], signal_in};  
            signal_out <= (shift_reg[0] + shift_reg[1] + shift_reg[2] > 1) ? 1'b1 : 1'b0;  
        end  
    end  
endmodule
module noise_suppression_filter(  
    input clk,  
    input rst,  
    input [4:0] noisy_input,  
    output reg [4:0] clean_output  
);  
    reg [4:0] shift_reg [0:2]; // 3-stage shift register for each bit  
    integer i;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            clean_output <= 5'b0;  
            for (i = 0; i < 3; i = i + 1)  
                shift_reg[i] <= 5'b0;  
        end else begin  
            // Shift the register  
            shift_reg[0] <= noisy_input;  
            shift_reg[1] <= shift_reg[0];  
            shift_reg[2] <= shift_reg[1];  
  
            // Calculate majority for each bit  
            for (i = 0; i < 5; i = i + 1) begin  
                clean_output[i] <= (shift_reg[0][i] + shift_reg[1][i] + shift_reg[2][i] > 1) ? 1'b1 : 1'b0;  
            end  
        end  
    end  
endmodule
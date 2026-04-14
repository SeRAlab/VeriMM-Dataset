module SISO_Shift_Register(  
    input wire clk,  
    input wire reset,  
    input wire Si,  
    output reg So  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 5'b00000;  
            So <= 1'b0;  
        end else begin  
            So <= shift_reg[0];  
            shift_reg <= {Si, shift_reg[4:1]};  
        end  
    end  
endmodule
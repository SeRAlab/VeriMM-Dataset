module SIPO_Shift_Register(  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 5'b0;  
            parallel_out <= 5'b0;  
        end else begin  
            shift_reg <= {shift_reg[3:0], serial_in};  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule
module PIPO_Shift_Register #(parameter WIDTH = 8) (  
    input clk,  
    input reset,  
    input load,  
    input shift,  
    input [WIDTH-1:0] parallel_in,  
    output reg [WIDTH-1:0] parallel_out,  
    output reg serial_out  
);  

    reg [WIDTH-1:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 0;  
            parallel_out <= 0;  
            serial_out <= 0;  
        end else if (load) begin  
            shift_reg <= parallel_in;  
            parallel_out <= shift_reg;  
        end else if (shift) begin  
            serial_out <= shift_reg[WIDTH-1];  
            shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule
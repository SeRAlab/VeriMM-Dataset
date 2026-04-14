module PISO_Shift_Register (  
    input wire [7:0] parallel_in,  
    input wire clk,  
    input wire load,  
    input wire shift_enable,  
    output reg serial_out  
);  
    reg [7:0] shift_reg;  
    
    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= parallel_in;  
        end else if (shift_enable) begin  
            serial_out <= shift_reg[7];  
            shift_reg <= {shift_reg[6:0], 1'b0};  
        end  
    end  
endmodule
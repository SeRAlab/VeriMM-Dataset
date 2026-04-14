module PISO_Shift_Register (  
    input clk,  
    input load,  
    input [3:0] data_in,  
    output reg serial_out  
);  
    reg [3:0] shift_reg;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= data_in;  
        end else begin  
            serial_out <= shift_reg[3];  
            shift_reg <= {shift_reg[2:0], 1'b0};  
        end  
    end  
endmodule
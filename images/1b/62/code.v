module PISO_Shift_Register (  
    input [4:0] data_in,  
    input load,  
    input clk,  
    output reg serial_out  
);  
    reg [4:0] shift_reg;  
    integer count;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= data_in;  
            count <= 0;  
        end else if (count < 5) begin  
            serial_out <= shift_reg[4];  
            shift_reg <= {shift_reg[3:0], 1'b0};  
            count <= count + 1;  
        end  
    end  
endmodule
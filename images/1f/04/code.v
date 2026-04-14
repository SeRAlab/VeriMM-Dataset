module SISO_Shift_Register(  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg [3:0] data_out  
);  

    reg [3:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 4'b0000;  
        end else begin  
            shift_reg <= {shift_reg[2:0], data_in};  
        end  
    end  

    always @(posedge clk) begin  
        data_out <= shift_reg;  
    end  
endmodule
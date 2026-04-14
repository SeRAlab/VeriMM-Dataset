module siso_shift_register (  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg [4:0] data_out  
);  

    reg [4:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 5'b00000;  
            data_out <= 5'b00000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], data_in};  
            data_out <= shift_reg;  
        end  
    end  
endmodule
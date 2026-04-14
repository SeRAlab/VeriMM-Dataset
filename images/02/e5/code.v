module siso_shift_register (  
    input clk,  
    input reset,  
    input data_in,  
    output reg data_out  
);  
    reg [4:0] shift_reg; // 5-bit shift register  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 5'b00000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], data_in};  
        end  
    end  

    always @(posedge clk) begin  
        data_out <= shift_reg[4];  
    end  
endmodule
module siso_shift_register (  
    input wire clk,  
    input wire rst,  
    input wire load,  
    input wire data_in,  
    output reg [3:0] data_out  
);  
    reg [3:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            shift_reg <= 4'b0000;  
        else if (load)  
            shift_reg <= {shift_reg[2:0], data_in};  
    end  

    always @(posedge clk) begin  
        data_out <= shift_reg;  
    end  
endmodule
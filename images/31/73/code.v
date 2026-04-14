module sipo_shift_register #(parameter WIDTH = 5) (  
    input wire clk,  
    input wire rst,  
    input wire serial_in,  
    output reg [WIDTH-1:0] parallel_out  
);  
    reg [WIDTH-1:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 0;  
            parallel_out <= 0;  
        end else begin  
            shift_reg <= {shift_reg[WIDTH-2:0], serial_in};  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule
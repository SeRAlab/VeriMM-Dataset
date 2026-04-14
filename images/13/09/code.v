module sipo_shift_register #(parameter WIDTH = 8) (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    input wire load,  
    output reg [WIDTH-1:0] parallel_out  
);  
    reg [WIDTH-1:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 0;  
            parallel_out <= 0;  
        end else if (load) begin  
            shift_reg <= {shift_reg[WIDTH-2:0], serial_in};  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule
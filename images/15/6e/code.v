module siso_shift_register (  
    input clk,  
    input serial_in,  
    output reg [3:0] parallel_out  
);  
    reg [3:0] shift_reg;  

    always @(posedge clk) begin  
        shift_reg <= {shift_reg[2:0], serial_in};  
    end  

    always @(posedge clk) begin  
        parallel_out <= shift_reg;  
    end  
endmodule
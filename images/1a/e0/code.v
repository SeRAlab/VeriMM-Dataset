module sipo_shift_register (  
    input wire clk,  
    input wire reset,  
    input wire serial_in,  
    output reg [4:0] parallel_out  
);  

reg [4:0] shift_reg;  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        shift_reg <= 5'b00000;  
    else  
        shift_reg <= {shift_reg[3:0], serial_in};  
end  

always @(posedge clk) begin  
    if (shift_reg[4])  
        parallel_out <= shift_reg;  
end  
endmodule
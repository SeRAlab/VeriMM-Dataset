module PIPO_Shift_Register (  
    input clk,  
    input reset,  
    input load,  
    input [7:0] parallel_in,  
    output reg [7:0] parallel_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        parallel_out <= 8'b0;  
    else if (load)  
        parallel_out <= parallel_in;  
end  
endmodule
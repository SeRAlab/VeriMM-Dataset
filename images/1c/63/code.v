module PIPO_Shift_Register #(parameter WIDTH = 5) (  
    input wire clk,  
    input wire reset,  
    input wire [WIDTH-1:0] parallel_in,  
    input wire load,  
    output reg [WIDTH-1:0] parallel_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            parallel_out <= 0;  
        else if (load)  
            parallel_out <= parallel_in;  
    end  
endmodule
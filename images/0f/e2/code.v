module PIPO_Shift_Register (  
    input wire clk,  
    input wire reset,  
    input wire load_enable,  
    input wire [4:0] parallel_in,  
    output reg [4:0] parallel_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            parallel_out <= 5'b00000;  
        else if (load_enable)  
            parallel_out <= parallel_in;  
    end  
endmodule
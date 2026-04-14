module PIPO_Shift_Register #(parameter N = 5) (  
    input [N-1:0] data_in,  
    input load,  
    input clk,  
    output reg [N-1:0] data_out  
);  
    always @(posedge clk) begin  
        if (load)  
            data_out <= data_in;  
    end  
endmodule
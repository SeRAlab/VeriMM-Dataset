module SIPO_Shift_Register(  
    input clk,  
    input serial_in,  
    output reg [3:0] parallel_out  
);  
    always @(posedge clk) begin  
        parallel_out <= {parallel_out[2:0], serial_in};  
    end  
endmodule
module shift_register (  
    input clk,  
    input reset,  
    input shift_enable,  
    input serial_in,  
    output reg [15:0] parallel_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            parallel_out <= 16'b0;  
        else if (shift_enable)  
            parallel_out <= {parallel_out[14:0], serial_in};  
    end  
endmodule
module shift_register (  
    input clk,  
    input enable,  
    input serial_in,  
    output reg [1:0] parallel_out  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            parallel_out <= {serial_in, parallel_out[1]};  
        end  
    end  
endmodule
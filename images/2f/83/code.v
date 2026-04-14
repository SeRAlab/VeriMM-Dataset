module shift_register(  
    input clk,  
    input shift_enable,  
    input load_enable,  
    input [15:0] parallel_in,  
    output reg [15:0] parallel_out  
);  
    always @(posedge clk) begin  
        if (load_enable) begin  
            parallel_out <= parallel_in;  
        end else if (shift_enable) begin  
            parallel_out <= {parallel_out[14:0], 1'b0};  
        end  
    end  
endmodule
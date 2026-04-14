module shift_register(  
    input clk,  
    input load,  
    input shift_left,  
    input shift_right,  
    input [15:0] parallel_in,  
    output reg [15:0] parallel_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            parallel_out <= parallel_in;  
        end else if (shift_left) begin  
            parallel_out <= {parallel_out[14:0], 1'b0};  
        end else if (shift_right) begin  
            parallel_out <= {1'b0, parallel_out[15:1]};  
        end  
    end  
endmodule
module shift_register (  
    input clk,  
    input reset,  
    input load,  
    input shift_dir,  // 1 for left, 0 for right  
    input [15:0] parallel_in,  
    output reg [15:0] shift_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shift_out <= 16'b0;  
        else if (load)  
            shift_out <= parallel_in;  
        else if (shift_dir)  
            shift_out <= {shift_out[14:0], 1'b0};  // shift left  
        else  
            shift_out <= {1'b0, shift_out[15:1]};  // shift right  
    end  
endmodule
module shift_register(  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [7:0] parallel_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            parallel_out <= 8'b00000000;  
        else  
            parallel_out <= {serial_in, parallel_out[7:1]};  
    end  
endmodule
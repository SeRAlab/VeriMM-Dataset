module shift_register(  
    input clk,  
    input reset,  
    input [7:0] parallel_in,  
    output reg [7:0] shift_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_out <= 8'b0;  
        end else begin  
            shift_out <= {shift_out[6:0], parallel_in[0]};  
        end  
    end  
endmodule
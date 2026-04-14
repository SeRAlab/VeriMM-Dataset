module shift_register(  
    input clk,  
    input reset,  
    input load,  
    input shift,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 16'b0;  
        else if (load)  
            data_out <= data_in;  
        else if (shift)  
            data_out <= {1'b0, data_out[15:1]};  
    end  
endmodule
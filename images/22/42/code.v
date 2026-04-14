module shift_register(  
    input clk,  
    input load,  
    input shift_left,  
    input shift_right,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (load)  
            data_out <= data_in;  
        else if (shift_left)  
            data_out <= {data_out[14:0], 1'b0};  
        else if (shift_right)  
            data_out <= {1'b0, data_out[15:1]};  
    end  
endmodule
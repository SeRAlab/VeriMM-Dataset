module shift_register (  
    input clk,  
    input reset,  
    input shift_left,  
    input shift_right,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            data_out <= 8'b00000000;  
        else if (shift_left)  
            data_out <= {data_out[6:0], 1'b0};  
        else if (shift_right)  
            data_out <= {1'b0, data_out[7:1]};  
        else  
            data_out <= data_in;  
    end  
endmodule
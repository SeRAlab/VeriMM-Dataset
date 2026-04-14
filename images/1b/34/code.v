module shift_register(  
    input clk,  
    input reset,  
    input shift_left,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        data_out <= 2'b00;  
    else if (shift_left)  
        data_out <= {data_out[0], data_in[0]};  
    else  
        data_out <= {data_in[1], data_out[1]};  
end  
endmodule
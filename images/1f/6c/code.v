module divide_by_2 (  
    input clk,  
    input reset,  
    input [7:0] input_value,  
    output reg [7:0] output_value  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        output_value <= 8'b0;  
    else  
        output_value <= input_value >> 1;  
end  

endmodule
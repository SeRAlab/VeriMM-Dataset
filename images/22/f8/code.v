module divide_by_4(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    output reg [1:0] quotient  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        quotient <= 2'b00;  
    else  
        quotient <= data_in / 4;  
end  
endmodule
module divide_by_4 (  
    input wire clk,  
    input wire reset,  
    input wire [1:0] in,  
    output reg [1:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 2'b00;  
        else  
            out <= in / 4;  
    end  
endmodule
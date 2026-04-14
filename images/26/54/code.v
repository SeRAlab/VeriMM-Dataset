module divide_by_4(  
    input wire clk,  
    input wire [1:0] in,  
    output reg [1:0] out  
);  
    always @(posedge clk) begin  
        if (in < 2'b100)  
            out <= in / 2'b100;  
        else  
            out <= 2'b11;  
    end  
endmodule
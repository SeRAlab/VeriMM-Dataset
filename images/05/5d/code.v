module divide_by_8(input [2:0] in,  
                    input clk,  
                    output reg [2:0] out);  

    always @(posedge clk) begin  
        out <= in / 8;  
    end  
endmodule
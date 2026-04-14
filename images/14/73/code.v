module divide_by_4(input [3:0] in, input clk, input en, output reg [3:0] out);  
    always @(posedge clk) begin  
        if (en) begin  
            out <= in >> 2;  
        end  
    end  
endmodule
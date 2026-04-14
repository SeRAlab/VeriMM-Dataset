module divide_by_2 (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] in,  
    output reg [3:0] out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            out <= 4'b0000;  
        end else begin  
            out <= in >> 1;  
        end  
    end  
endmodule
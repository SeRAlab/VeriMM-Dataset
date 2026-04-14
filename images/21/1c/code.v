module divide_by_4 (  
    input wire clk,  
    input wire [1:0] in,  
    output reg out  
);  
    always @(posedge clk) begin  
        if (in == 2'b00)  
            out <= 1;  
        else  
            out <= 0;  
    end  
endmodule
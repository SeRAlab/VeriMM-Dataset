module divide_by_8 (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [2:0] quotient  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            quotient <= 3'b000;  
        end else begin  
            quotient <= data_in / 8;  
        end  
    end  
endmodule
module divide_by_8 (  
    input wire clk,  
    input wire rst,  
    output reg out  
);  
    reg [2:0] count;  // 3-bit counter to count up to 7 (0-7)  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            count <= 3'b000;  
            out <= 0;  
        end else if (count == 3'b111) begin  
            count <= 3'b000;  
            out <= 1;  
        end else begin  
            count <= count + 1;  
            out <= 0;  
        end  
    end  
endmodule
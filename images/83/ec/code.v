module BinaryCounter_4bit(
   input                clk ,
   input                rst_n,
 
   output reg [3:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 4'b0;
        else Q <= Q + 1;
    end
endmodule
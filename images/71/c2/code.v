module UpDownCounter_3bit(
   input                clk ,
   input                rst_n,
   input                up_down,
 
   output reg [2:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 3'b0;
        else if(up_down) Q <= Q + 1;
        else Q <= Q - 1;
    end
endmodule
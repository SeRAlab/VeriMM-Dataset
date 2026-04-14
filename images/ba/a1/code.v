module BCD_counter_4(
   input                clk ,
   input                rst_n,
 
   output reg [3:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 4'd0;
        else if(Q == 4'd9) Q <= 4'd0;
        else Q <= Q + 4'd1;
    end
endmodule
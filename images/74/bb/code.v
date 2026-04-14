module up_counter(
   input                clk ,
   input                rst_n,
   input                en,
 
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 'd0;
        else if(en) Q <= Q + 1;
    end
endmodule
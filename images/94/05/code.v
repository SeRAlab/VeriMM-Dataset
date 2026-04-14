module UD_counter_8(
   input                clk ,
   input                rst_n,
   input                dir,
 
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'd0;
        else if(dir) Q <= Q + 8'd1;
        else Q <= Q - 8'd1;
    end
endmodule
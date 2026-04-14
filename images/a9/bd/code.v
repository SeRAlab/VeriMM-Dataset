module binary_counter_8(
   input                clk ,
   input                rst_n,
 
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'd0;
        else if(Q == 8'd255) Q <= 8'd0;
        else Q <= Q + 8'd1;
    end
endmodule
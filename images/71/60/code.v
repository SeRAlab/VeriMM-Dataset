module Binary_counter_16(
   input                clk ,
   input                rst_n,
   input  [15:0]        limit,
 
   output reg [15:0]    Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 16'd0;
        else if(Q < limit) Q <= Q + 16'd1;
    end
endmodule
module binary_up_counter_8(
   input                clk ,
   input                rst_n,
 
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'b00000000;
        else Q <= Q + 1;
    end
endmodule
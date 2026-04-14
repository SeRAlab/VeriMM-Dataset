module ring_counter(
   input                clk,
   input                rst_n,
 
   output reg [2:0]     Q
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 3'b001;
        else Q <= {Q[1:0], Q[2]};
    end
endmodule
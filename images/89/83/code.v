module ring_counter_5(
   input                clk,
   input                rst_n,

   output reg [4:0]     Q
);
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Q <= 5'b10000;
        else Q <= {Q[3:0], Q[4]};
    end
endmodule
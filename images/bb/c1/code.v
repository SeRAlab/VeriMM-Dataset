module ring_counter_5(
   input                clk,
   input                rst,

   output reg [4:0]     Q
);
    always@(posedge clk) begin
        if(rst) Q <= 5'b00001;
        else Q <= {Q[3:0], Q[4]};
    end
endmodule
module Johnson_counter_10(
   input                clk,
   input                rst_n,
   
   output reg [9:0]     Q
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 10'd0;
        else Q <= {~Q[9], Q[9:1]};
    end
endmodule
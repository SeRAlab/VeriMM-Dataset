module ring_counter(
   input                clk,
   input                rst_n,

   output reg [11:0]    Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 12'b000000000001;
        else Q <= {Q[10:0], Q[11]};
    end
endmodule
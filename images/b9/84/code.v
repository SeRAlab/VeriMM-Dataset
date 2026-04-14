module JC_counter_20(
   input                clk,
   input                rst_n,
   
   output reg [19:0]    Q
);
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 'd0;
        else if (!Q[0]) Q <= {1'b1, Q[19:1]};
        else Q <= {1'b0, Q[19:1]};
    end
endmodule
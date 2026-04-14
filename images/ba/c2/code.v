module JC_counter_8(
   input                clk,
   input                rst_n,
   
   output reg [7:0]     Q
);
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 'd0;
        else if (!Q[0]) Q <= {1'b1, Q[7:1]};
        else Q <= {1'b0, Q[7:1]};
    end
endmodule
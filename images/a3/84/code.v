module ring_counter(clk, reset, q);
    input clk, reset;
    output reg [3:0] q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 4'b0001;
        else
            q <= {q[2:0], q[3]};
    end
endmodule
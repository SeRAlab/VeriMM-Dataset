module ring_counter4 (
    input clk,
    output reg [3:0] q
);

    always_ff @(posedge clk) begin
        if (q == 4'b0)
            q <= 4'b0001;
        else
            q <= {q[2:0], q[3]};
    end

endmodule
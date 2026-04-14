module shift_register (
    input clk,
    input reset,
    input direction,
    output reg [6:0] q
);always @(posedge clk) begin
        if (reset)
            q <= 7'b0000001;
        else if (direction)
            q <= {q[5:0], 1'b0};
        else
            q <= {1'b0, q[6:1]};
    end

endmodule
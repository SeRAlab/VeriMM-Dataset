module bidirectional_shift_register (
    input clk,
    input reset,
    input enable,
    input direction,
    output reg [2:0] q
);always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 3'b000;
        else if (enable) begin
            if (direction)
                q <= {q[1:0], 1'b0};
            else
                q <= {1'b0, q[2:1]};
        end
    end

endmodule
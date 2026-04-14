module ring_counter (
    input clk,
    input reset,
    input enable,
    output reg [2:0] q
);always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 3'b001;
        else if (enable)
            q <= {q[1:0], q[2]};
    end

endmodule
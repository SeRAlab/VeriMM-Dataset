module johnson_counter (
    input clk,
    input reset,
    input enable,
    output reg [7:0] q
);always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'b00000001;
        else if (enable)
            q <= {q[6:0], ~q[7]};
    end

endmodule
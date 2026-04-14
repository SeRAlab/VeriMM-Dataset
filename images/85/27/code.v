module shift_register(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'd0;
        else
            q <= {q[6:0], d[7]};
    end
endmodule
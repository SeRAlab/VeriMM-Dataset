module shift_register4 (
    input clk,
    input sh,
    input [3:0] d,
    output reg [3:0] q
);

    always_ff @(posedge clk) begin
        if (sh)
            q <= {q[2:0], d[0]};
    end

endmodule
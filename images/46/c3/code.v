module shift_register8 (
    input [7:0] d,
    input clk,
    input ld,
    output reg [7:0] q
);

    always_ff @(posedge clk) begin
        if (ld)
            q <= d;
        else
            q <= {q[6:0], 1'b0};
    end

endmodule
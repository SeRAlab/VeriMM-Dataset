module shift_register (
    input [3:0] d,
    input clk,
    input shift_en,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_en)
            q <= {1'b0, q[3:1]};
        else
            q <= d;
    end

endmodule
module shift_register(
    input clk,
    input s_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        q <= {q[2:0], s_in};
    end

endmodule
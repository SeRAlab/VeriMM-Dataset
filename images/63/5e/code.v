module shift_register_4bit(
    input [3:0] d,
    input clk,
    input sh,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (sh)
            q <= {q[2:0], d[3]};
        else
            q <= d;
    end
endmodule
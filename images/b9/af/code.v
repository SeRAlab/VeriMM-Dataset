module shift_reg (
    input wire clk,
    input wire d,
    output reg [2:0] q
);

    always @(posedge clk) begin
        q <= {q[1:0], d};
    end

endmodule
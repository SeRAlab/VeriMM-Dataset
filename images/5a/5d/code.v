module shift_reg_8bit(
    input               clk,
    input               load,
    input [7:0]         d,
    output reg [7:0]    q
);

always @(posedge clk) begin
    if (load)
        q <= d;
    else
        q <= {q[6:0], 1'b0}; // Shift left
end

endmodule
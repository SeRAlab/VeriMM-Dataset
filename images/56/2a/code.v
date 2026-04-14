module shift_reg_parallel_load (
    input wire [7:0] d,
    input wire clk,
    input wire load,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (load)
        q <= d;
    else
        q <= {q[6:0], 1'b0};
end

endmodule
module shift_register(
    input [3:0] d,
    input clk,
    input load,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= d;
    end else begin
        q <= {q[2:0], 1'b0};
    end
end

endmodule
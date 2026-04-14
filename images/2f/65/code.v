module shift_register (
    input wire clk,
    input wire load,
    input wire shift_left,
    input wire [1:0] parallel_in,
    output reg [1:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= parallel_in;
    end else if (shift_left) begin
        q <= {q[0], 1'b0};  // Shift left and fill rightmost bit with 0
    end else begin
        q <= {1'b0, q[1]};  // Shift right and fill leftmost bit with 0
    end
end

endmodule
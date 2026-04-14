module shift_register(
    input clk,
    input shift,
    input [3:0] data_in,
    output reg [3:0] q);always @(posedge clk) begin
    if (shift)
        q <= {1'b0, q[3:1]};
    else
        q <= data_in;
end

endmodule
module shift_register_8bit(
    input clk,
    input rst,
    input serial_in,

    output reg [7:0] q
);

// Shift Register logic
always @(posedge clk) begin
    if (rst)
        q <= 8'b00000000;
    else
        q <= {serial_in, q[7:1]};
end

endmodule
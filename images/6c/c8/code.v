module shift_register_4bit(
    input clk,
    input sin,

    output reg [3:0] q
);

// Shift register logic
always @(posedge clk) begin
    q <= {sin, q[3:1]};
end

endmodule
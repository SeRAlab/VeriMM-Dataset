module shift_register_4bit(
    input wire CLK,
    input wire SI,
    output reg [3:0] Q
    );

always @(posedge CLK) begin
    Q <= {Q[2:0], SI};
end

endmodule
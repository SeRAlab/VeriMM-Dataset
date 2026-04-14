module shift_register_4bit(
    input clk,
    input serial_in,
    output reg [3:0] Q
);

always @(posedge clk)
begin
    Q <= {Q[2:0], serial_in};
end

endmodule
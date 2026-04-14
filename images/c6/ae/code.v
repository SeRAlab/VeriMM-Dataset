module johnson_counter (
    input clk,
    output reg [3:0] Q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    shift_reg <= {shift_reg[2:0], shift_reg[3]};
    Q <= shift_reg[0] ^ shift_reg[3];
end

endmodule
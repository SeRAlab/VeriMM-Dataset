module shift_register(
    input [3:0] P,
    input clk,
    input load,
    output reg Q
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (load)
        shift_reg <= P;
    else
        shift_reg <= {1'b0, shift_reg[3:1]};
end

assign Q = shift_reg[0];

endmodule
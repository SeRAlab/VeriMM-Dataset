module top_module(
    input [3:0] D,
    input PL,
    input CLK,
    output reg Q
);reg [3:0] shift_reg;

always @ (posedge CLK) begin
    if (PL) begin
        shift_reg <= D;
    end else begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end
end

assign Q = shift_reg[0];

endmodule
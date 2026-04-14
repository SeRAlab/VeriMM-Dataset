module top_module(
    input CLK,
    output reg Q0,
    output reg Q1,
    output reg Q2
);reg [2:0] lfsr_reg;

always @(posedge CLK) begin
    lfsr_reg <= {lfsr_reg[1:0], lfsr_reg[2] ^ lfsr_reg[1]};
end

assign Q0 = lfsr_reg[0];
assign Q1 = lfsr_reg[1];
assign Q2 = lfsr_reg[2];

endmodule
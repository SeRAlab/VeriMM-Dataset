module top_module(
    clk,
    Load,
    not_reset,
    D,
    Q
);input wire clk;
input wire not_reset;
input wire Load;
input wire [7:0] D;
output wire [7:0] Q;

reg [7:0] Q_ALTERA_SYNTHESIZED;

always @(posedge clk) begin
    if (not_reset == 0) begin
        Q_ALTERA_SYNTHESIZED <= 8'b0;
    end else if (Load == 1) begin
        Q_ALTERA_SYNTHESIZED <= D;
    end
end

assign Q = Q_ALTERA_SYNTHESIZED;

endmodule
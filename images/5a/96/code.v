module top_module(
    clk,
    Load,
    not_reset,
    D,
    Q
);input wire clk;
input wire not_reset;
input wire Load;
input wire [15:0] D;
output wire [15:0] Q;

reg [15:0] Q_ALTERA_SYNTHESIZED;

always @(posedge clk or negedge not_reset) begin
    if (!not_reset) begin
        Q_ALTERA_SYNTHESIZED <= 0;
    end else if (Load) begin
        Q_ALTERA_SYNTHESIZED <= D;
    end
end

assign Q = Q_ALTERA_SYNTHESIZED;

endmodule
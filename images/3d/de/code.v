module DFlipFlop(
    input wire D,
    input wire clk,
    input wire enable,
    output reg Q
);

always @(posedge clk) begin
    if (enable) begin
        Q <= D;
    end
end

endmodule
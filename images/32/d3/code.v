module d_flip_flop (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire D,
    output reg Q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 0; // Asynchronous reset
    end else if (enable) begin
        Q <= D; // Store D when enabled
    end
end

endmodule
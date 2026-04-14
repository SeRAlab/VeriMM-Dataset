module d_flip_flop(
    input D,           // Data input.
    input clk,         // Clock signal.
    input rst,         // Synchronous reset signal.
    input set,         // Synchronous set signal.

    output reg Q       // Output of the flip-flop.
);

//------------------------------------------------
// D Flip-Flop logic
always @(posedge clk) begin
    if (rst) begin
        Q <= 1'b0;
    end else if (set) begin
        Q <= 1'b1;
    end else begin
        Q <= D;
    end
end

endmodule
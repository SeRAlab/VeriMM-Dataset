module top_module(
    input D,
    input RESET,
    output reg Q,
    input GATE
);always @(posedge GATE or posedge RESET) begin
        if (RESET) begin
            Q <= 1'b0; // Reset Q to 0 on RESET signal
        end else begin
            Q <= D; // Set Q to D on GATE signal
        end
    end

endmodule
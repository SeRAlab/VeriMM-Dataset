module top_module(
    input CLK,
    input D,
    input RESET,
    input SET,
    output reg Q
);always @(posedge CLK or posedge RESET or posedge SET) begin
        if (RESET) begin
            Q <= 1'b0; // Reset state
        end else if (SET) begin
            Q <= 1'b1; // Set state
        end else begin
            Q <= D; // Normal D flip-flop behavior
        end
    end

endmodule
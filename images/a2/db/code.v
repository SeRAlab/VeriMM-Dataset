module top_module(
    input CLK,
    input D,
    input RESETn,
    input ENn,
    output reg Q,      // Change output to reg
    output Q_N
);assign Q_N = ~Q;  // Q_N can remain as a wire

    always @(posedge CLK) begin
        if (!RESETn) begin
            Q <= 1'b0;
        end else if (!ENn) begin
            Q <= Q; // Retain state when ENn is not asserted
        end else begin
            Q <= D;
        end
    end

endmodule
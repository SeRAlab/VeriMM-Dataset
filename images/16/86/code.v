module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output reg Q_not
);

always @(posedge CLK) begin
    if (J && ~K) begin
        Q <= 1; // Set
    end else if (~J && K) begin
        Q <= 0; // Reset
    end else if (J && K) begin
        Q <= ~Q; // Toggle
    end
    Q_not <= ~Q; // Complement of Q
end

endmodule
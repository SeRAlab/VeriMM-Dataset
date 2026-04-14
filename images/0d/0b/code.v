module D_latch(
    input wire D,
    input wire E,
    output reg Q
);

always @(D or E) begin
    if (E) begin
        Q <= D;  // If Enable is high, output follows D
    end
    // If E is low, Q retains its value
end

endmodule
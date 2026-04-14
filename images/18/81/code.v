module d_latch (
    input wire D,
    input wire En,
    output reg Q
);

always @(D or En) begin
    if (En) begin
        Q <= D;
    end
    // If En is low, Q retains its previous value
end

endmodule
module T_latch (
    input wire T,
    input wire E,
    output reg Q
);

always @(posedge E) begin
    if (T) begin
        Q <= ~Q; // Toggle Q if T is high
    end
end

endmodule
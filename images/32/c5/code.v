module JK_latch (
    input J,
    input K,
    input CLK,
    output reg Q,
    output Qn
);
    assign Qn = ~Q;

    always @(posedge CLK) begin
        if (J && ~K) begin
            Q <= 1; // Set
        end else if (~J && K) begin
            Q <= 0; // Reset
        end else if (J && K) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule
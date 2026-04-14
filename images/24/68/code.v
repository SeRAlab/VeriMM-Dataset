module jk_flip_flop (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J && K) begin
            Q <= ~Q; // Toggle
        end else if (J && ~K) begin
            Q <= 1; // Set high
        end else if (~J && K) begin
            Q <= 0; // Set low
        end // If both J and K are low, do nothing
    end
endmodule
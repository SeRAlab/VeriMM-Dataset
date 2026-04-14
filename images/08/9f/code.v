module sr_flip_flop (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q,
    output wire Qbar
);
    assign Qbar = ~Q;

    always @(posedge clk) begin
        if (S && R)
            Q <= 0;  // Invalid state
        else if (S)
            Q <= 1;  // Set state
        else if (R)
            Q <= 0;  // Reset state
        // Else Q retains its previous state
    end
endmodule
module sr_flip_flop (
    input wire S,
    input wire R,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(posedge S or posedge R) begin
        if (R) begin
            Q <= 0; // Reset state
        end else if (S) begin
            Q <= 1; // Set state
        end
        // Hold state implicitly if both S and R are low
    end
endmodule
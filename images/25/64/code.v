module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK) begin
        if (S && R) begin
            // Do nothing to maintain the previous state
            Q <= Q; // Hold state
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        Qn <= ~Q; // Complement output
    end
endmodule
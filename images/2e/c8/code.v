module sr_flip_flop (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    
    always @ (S or R) begin
        if (S && R) begin
            // Forbidden state: do nothing or can signal an error
        end else if (S) begin
            Q <= 1'b1; // Set
        end else if (R) begin
            Q <= 1'b0; // Reset
        end
        Qn <= ~Q; // Qn is the complement of Q
    end
endmodule
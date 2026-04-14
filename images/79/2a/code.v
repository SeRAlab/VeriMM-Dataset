module top_module(D, Q, C, R, S);input D;
    input C;
    input R;
    input S;
    output reg Q; // Changed to reg to hold the output state

    always @(posedge C) begin
        if (S) begin
            Q <= 1; // Set Q high on Set signal
        end else if (R) begin
            Q <= 0; // Set Q low on Reset signal
        end else begin
            Q <= D; // D flip-flop functionality
        end
    end
endmodule
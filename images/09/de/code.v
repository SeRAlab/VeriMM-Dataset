module master_slave_d_latch (
    input D,
    input E,
    output reg Q,
    output reg Q_not
);
    reg master_Q;

    always @(D or E) begin
        if (E) begin
            master_Q = D; // Capture data when Enable is high
        end
    end

    always @(master_Q or E) begin
        if (!E) begin
            Q = master_Q; // Latch the value when Enable goes low
            Q_not = ~Q;   // Q_not is the inverse of Q
        end
    end
endmodule
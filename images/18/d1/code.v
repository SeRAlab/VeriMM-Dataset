module master_slave_d_latch (
    input wire D,
    input wire E,
    output reg Q,
    output reg Qn
);
    reg temp;

    // Master latch
    always @(E or D) begin
        if (E) begin
            temp = D; // Capture data when enable is high
        end
    end

    // Slave latch
    always @(E or temp) begin
        if (!E) begin
            Q = temp; // Transfer data to output when enable is low
            Qn = ~temp;
        end
    end
endmodule
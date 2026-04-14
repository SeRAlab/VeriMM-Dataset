module flash_memory_cell (
    input wire D,
    input wire C,
    input wire reset,
    output wire Q
);
    reg Q_reg;

    always @(*) begin
        if (reset) begin
            Q_reg = 1'b0; // Initialize to 0
        end else if (C) begin
            Q_reg = D; // Write D to Q
        end
    end

    assign Q = Q_reg;
endmodule
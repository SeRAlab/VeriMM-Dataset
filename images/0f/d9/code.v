module flash_memory_cell (
    input wire D,
    input wire C,
    output wire Q
);
    reg Q_reg;

    always @(*) begin
        if (C) begin
            Q_reg = D;  // Update output Q with input D when control C is high
        end
    end

    assign Q = Q_reg;  // Continuous assignment to output Q
endmodule
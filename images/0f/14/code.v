module dram_cell (
    input wire D,
    input wire WL,
    input wire EN,
    output reg Q,
    output reg BL
);
    always @(*) begin
        if (EN) begin
            if (WL) begin
                Q <= D;  // Write data
            end
        end
        BL <= (EN == 0 && WL == 0) ? Q : 1'bz; // High-Z if reading
    end
endmodule
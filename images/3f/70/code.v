module flash_memory_cell (
    input wire DATA,
    input wire WRITE,
    output reg Q
);
    always @(*) begin
        if (WRITE) begin
            Q = DATA; // Write data to the cell
        end
    end
endmodule
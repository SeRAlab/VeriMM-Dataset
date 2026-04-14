module flash_memory_cell (
    input wire D,
    input wire C,
    output reg Q
);
    always @(posedge C or negedge C) begin
        if (C)
            Q <= D;  // Write data to memory cell
        // else retain current value
    end
endmodule
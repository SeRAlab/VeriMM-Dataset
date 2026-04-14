module flash_memory_cell(
    input wire D,
    input wire W,
    input wire R,
    input wire E,
    output reg Q
);
    initial begin
        Q = 1'b0;  // Initialize the memory cell to 0
    end

    always @(posedge W or posedge E) begin
        if (E) begin
            Q <= 1'b0;  // Erase operation
        end else if (W) begin
            Q <= D;     // Write operation
        end
    end

    always @(posedge R) begin
        // Read operation (output is updated on read)
        if (R) begin
            Q <= Q;  // Maintain current output
        end
    end
endmodule
module dram_cell (
    input wire D,      // Data input
    input wire WL,     // Write line
    input wire SL,     // Sense line
    output reg Q       // Output stored value
);
    always @(posedge WL) begin
        Q <= D;        // Store the input data when WL is high
    end
    
    always @(posedge SL) begin
        // Output the stored value when SL is high (no action needed on output)
    end
endmodule
module dram_cell (
    input wire D,
    input wire WL,
    output reg Q
);
    always @(posedge WL or negedge WL) begin
        if (WL) begin
            Q <= D; // Store data when WL is high
        end
        // When WL is low, Q retains its value
    end
endmodule
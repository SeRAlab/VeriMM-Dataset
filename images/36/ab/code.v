module dram_cell (
    input wire D,
    input wire WL,
    output reg Q
);
    always @(posedge WL) begin
        Q <= D; // Store data on the rising edge of WL
    end
endmodule
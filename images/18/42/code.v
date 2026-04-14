module dram_cell (
    input wire D,
    input wire WL,
    output reg Q
);
    always @(posedge WL) begin
        Q <= D; // Store the value of D when WL is high
    end
endmodule
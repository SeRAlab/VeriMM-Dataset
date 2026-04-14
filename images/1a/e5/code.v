module dram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    input wire CLK,
    output reg Q
);
    reg stored_bit;

    always @(posedge CLK) begin
        if (WE) begin
            stored_bit <= D; // Write operation
        end
        if (RE) begin
            Q <= stored_bit; // Read operation
        end
    end
endmodule
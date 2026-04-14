module sram_1bit (
    input wire D,
    input wire WE,
    input wire CLK,
    output reg Q
);
    reg memory; // 1-bit memory cell

    always @(posedge CLK) begin
        if (WE) begin
            memory <= D; // Write data
        end
    end

    always @(*) begin
        Q = memory; // Read data
    end
endmodule
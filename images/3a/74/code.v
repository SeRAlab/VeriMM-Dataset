module dram_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    output reg Q
);
    reg stored_data;

    always @(posedge CLK) begin
        if (WE) begin
            stored_data <= D; // Write data to the cell on WE high
        end
        Q <= stored_data; // Output the stored data
    end
endmodule
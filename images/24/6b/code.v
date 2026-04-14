module dram_cell (
    input wire d,
    input wire we,
    input wire clk,
    input wire r,
    output reg q
);
    reg stored_bit;

    always @(posedge clk) begin
        if (we) begin
            stored_bit <= d; // Write data to the cell
        end
    end

    always @(posedge clk) begin
        if (r) begin
            q <= stored_bit; // Read data from the cell
        end
    end
endmodule
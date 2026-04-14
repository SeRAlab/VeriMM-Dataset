module dram_cell (
    input wire clk,
    input wire we,
    input wire d_in,
    output reg d_out
);
    reg stored_bit;

    always @(posedge clk) begin
        if (we) begin
            stored_bit <= d_in; // Store data on write enable
        end
    end

    always @(negedge clk) begin
        if (!we) begin
            d_out <= stored_bit; // Output the stored data on negative edge if we is low
        end
    end
endmodule
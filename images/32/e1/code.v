module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire re, // read enable
    input wire d,  // data input
    output reg q   // data output
);
    reg stored_bit;

    always @(posedge clk) begin
        if (we) begin
            stored_bit <= d; // Store data on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= stored_bit; // Output the stored data on read enable
        end
    end
endmodule
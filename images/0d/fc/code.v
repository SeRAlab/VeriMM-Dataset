module dram_cell (
    input wire clk,
    input wire we,      // write enable
    input wire re,      // read enable
    input wire [3:0] data_in, // 4-bit input data
    output reg [3:0] data_out  // 4-bit output data
);
    reg [3:0] storage; // 4-bit storage for the DRAM cell

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Store input data on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= storage; // Output stored data on read enable
        end
    end
endmodule
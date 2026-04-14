module dram_cell(
    input clk,
    input we, // write enable
    input re, // read enable
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] storage; // 16-bit storage

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule
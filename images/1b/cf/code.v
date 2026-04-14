module dram_cell(
    input wire [3:0] data_in,
    input wire clk,
    input wire we, // write enable
    input wire re, // read enable
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (we) begin
            storage <= data_in; // Write data to storage on clock edge
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= storage; // Output the stored data when read is enabled
        end
    end
endmodule
module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] storage; // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= storage; // Output data from storage
        end
    end
endmodule
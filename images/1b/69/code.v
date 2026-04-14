module sram_cell (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [3:0] data_out,
    input wire clk
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= data_in; // Write data to storage
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= storage; // Read data from storage
        end
    end
endmodule
module dram_cell (
    input wire clk,
    input wire write_en,
    input wire read_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] storage;

    always @(posedge clk) begin
        if (write_en) begin
            storage <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= storage;
        end
    end
endmodule
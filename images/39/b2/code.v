module dram_cell (
    input wire [3:0] data_in,
    input wire read_en,
    input wire write_en,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] stored_data;

    always @(posedge clk) begin
        if (write_en) begin
            stored_data <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= stored_data;
        end
    end
endmodule
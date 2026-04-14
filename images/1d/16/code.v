module sram_cell (
    input wire [3:0] input_data,
    output reg [3:0] output_data,
    input wire write_enable,
    input wire read_enable,
    input wire clk
);
    reg [3:0] storage;

    always @(posedge clk) begin
        if (write_enable) begin
            storage <= input_data;  // Store data on write enable
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            output_data <= storage;  // Output data on read enable
        end
    end
endmodule
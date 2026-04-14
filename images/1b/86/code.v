module sram_cell (
    input wire write_enable,
    input wire data_in,
    input wire clk,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in; // Store data input on write enable
        end
    end

    always @(*) begin
        data_out = stored_data; // Output the stored data
    end
endmodule
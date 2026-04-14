module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire refresh_enable,
    input wire data_in,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (refresh_enable) begin
            stored_data <= 1'b0; // Refresh operation resets the cell
        end else if (write_enable) begin
            stored_data <= data_in; // Write operation stores data
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data; // Read operation outputs stored data
        end
    end
endmodule
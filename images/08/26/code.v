module dram_cell(
    input wire data_in,
    input wire we,
    input wire clk,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (we) begin
            stored_data <= data_in; // Write data
        end
    end

    always @(posedge clk) begin
        data_out <= stored_data; // Read data
    end
endmodule
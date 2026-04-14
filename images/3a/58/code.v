module dram_cell (
    input wire [7:0] data_in,
    input wire re,
    input wire we,
    output reg [7:0] data_out,
    input wire clk
);
    reg [7:0] stored_data;

    always @(posedge clk) begin
        if (we) begin
            stored_data <= data_in; // Write data on WE
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= stored_data; // Read data on RE
        end
    end
endmodule
module dram_cell (
    input wire wordline,
    input wire data_in,
    input wire clk,
    input wire write_enable,
    output reg data_out
);
    reg storage;

    always @(posedge clk) begin
        if (wordline) begin
            if (write_enable) begin
                storage <= data_in;  // Write data to storage
            end
            data_out <= storage;  // Read data from storage
        end
    end
endmodule
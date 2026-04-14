module flash_memory_cell (
    input wire clk,
    input wire write_en,
    input wire data_in,
    output reg data_out
);

    always @(posedge clk) begin
        if (write_en) begin
            data_out <= data_in; // Store data when write_en is high
        end
    end

endmodule
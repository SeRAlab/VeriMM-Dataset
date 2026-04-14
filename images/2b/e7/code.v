module flash_memory (
    input wire clk,
    input wire write_enable,
    input wire erase_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (erase_enable) begin
            data_out <= 8'b00000000; // Erase the memory cell
        end else if (write_enable) begin
            data_out <= data_in; // Write data to the memory cell
        end
        // else: retain the current data_out value
    end
endmodule
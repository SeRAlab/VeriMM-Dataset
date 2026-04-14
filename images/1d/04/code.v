module flash_memory_cell (
    input clk,
    input rst,
    input [1:0] operation, // 00: read, 01: write, 10: erase
    input data_in,
    output reg data_out
);
    // Internal state
    reg memory_cell;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory_cell <= 1'b0; // Reset memory cell
            data_out <= 1'b0;
        end else begin
            case (operation)
                2'b00: data_out <= memory_cell; // Read operation
                2'b01: memory_cell <= data_in;   // Write operation
                2'b10: memory_cell <= 1'b0;       // Erase operation
                default: data_out <= data_out;    // No operation
            endcase
        end
    end
endmodule
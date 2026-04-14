module flash_memory_controller(
    input clk,
    input [1:0] op,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory_cell;

    always @(posedge clk) begin
        case (op)
            2'b00: data_out <= memory_cell; // Read
            2'b01: memory_cell <= data_in;   // Write
            2'b10: memory_cell <= 8'b00000000; // Erase
            2'b11: data_out <= data_out; // NOP
            default: data_out <= 8'b00000000;
        endcase
    end
endmodule
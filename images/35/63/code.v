module SRAM_Cell(
    input wire clk,
    input wire rw, // rw = 1 for read, rw = 0 for write
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (rw == 0) begin // Write
            memory <= data_in;
        end else begin // Read
            data_out <= memory;
        end
    end
endmodule
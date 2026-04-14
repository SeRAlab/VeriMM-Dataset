module top_module(
    address,
    byteena,
    clock,
    data,
    wren,
    q
);parameter WORD_SIZE = 16;
    parameter WORDS = 76800;
    parameter BYTE_SIZE = 8;
    parameter BYTES = WORD_SIZE / BYTE_SIZE;

    input [16:0] address;
    input [1:0] byteena;
    input clock;
    input [WORD_SIZE-1:0] data;
    input wren;
    output reg [WORD_SIZE-1:0] q;

    reg [WORD_SIZE-1:0] mem [0:WORDS-1];

    always @(posedge clock) begin
        if (wren) begin
            case (byteena)
                2'b00: mem[address][7:0] <= data[7:0];
                2'b01: mem[address][15:8] <= data[7:0];
                2'b10: mem[address][23:16] <= data[7:0];
                2'b11: mem[address][31:24] <= data[7:0];
            endcase
        end
        case (byteena)
            2'b00: q <= mem[address][7:0];
            2'b01: q <= mem[address][15:8];
            2'b10: q <= mem[address][23:16];
            2'b11: q <= mem[address][31:24];
        endcase
    end

endmodule
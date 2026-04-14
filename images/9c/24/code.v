module top_module(
    input CLK,
    input RESET,
    input WEN,
    input REN,
    input valid,
    input [WIDTH-1:0] Data_in, // Changed to a single input
    output reg [WIDTH-1:0] Data_out, // Changed to reg type
    output [DEPTH-1:0] Full_out,
    output [DEPTH-1:0] Empty_out
);parameter DEPTH = 8, ADDRESS_WIDTH = 3, WIDTH=8;

reg [ADDRESS_WIDTH-1:0] write_ptr = 0;
reg [ADDRESS_WIDTH-1:0] read_ptr = 0;

reg [DEPTH-1:0] full = 0;
reg [DEPTH-1:0] empty = 1;

reg [WIDTH-1:0] mem [0:(1<<ADDRESS_WIDTH)-1];

assign Full_out = full;
assign Empty_out = empty;

always @(posedge CLK) begin
    if (RESET) begin
        write_ptr <= 0;
        read_ptr <= 0;
        full <= 0;
        empty <= 1;
    end else if (WEN && !full) begin
        mem[write_ptr] <= Data_in;
        write_ptr <= write_ptr + 1;
        if (write_ptr == DEPTH - 1) begin
            write_ptr <= 0;
        end
        if (write_ptr == read_ptr) begin
            full <= 1; // Set full when write_ptr meets read_ptr
        end
        empty <= 0;
    end else if (REN && !empty) begin
        Data_out <= mem[read_ptr]; // Now valid as a reg type
        read_ptr <= read_ptr + 1;
        if (read_ptr == DEPTH - 1) begin
            read_ptr <= 0;
        end
        if (read_ptr == write_ptr) begin
            empty <= 1; // Set empty when read_ptr meets write_ptr
        end
        full <= 0;
    end
end

endmodule
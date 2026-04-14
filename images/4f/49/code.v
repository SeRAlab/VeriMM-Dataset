module top_module(
    input clk,
    input rst,
    input rd,
    input wr,
    input [7:0] data_in,
    output reg [7:0] data_out, // Changed wire to reg
    output empty,
    output full
);parameter DEPTH = 16;

reg [7:0] memory [0:DEPTH-1];
reg [3:0] write_ptr = 0;
reg [3:0] read_ptr = 0;
wire [3:0] next_write_ptr = write_ptr + 1;
wire [3:0] next_read_ptr = read_ptr + 1;

assign empty = (write_ptr == read_ptr);
assign full = (next_write_ptr == read_ptr);

always @(posedge clk) begin
    if (rst) begin
        write_ptr <= 0;
        read_ptr <= 0;
        data_out <= 0; // Initialize data_out when reset
    end else begin
        if (wr && !full) begin
            memory[write_ptr] <= data_in;
            write_ptr <= next_write_ptr;
        end
        if (rd && !empty) begin
            data_out <= memory[read_ptr];
            read_ptr <= next_read_ptr;
        end
    end
end

endmodule
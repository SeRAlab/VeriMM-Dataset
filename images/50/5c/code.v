module top_module(
    input clk,
    input rst_n,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output [7:0] data_out,
    output empty,
    output full,
    output reg [5:0] count
);reg [7:0] mem [0:63];
reg [5:0] write_ptr;
reg [5:0] read_ptr;
reg [5:0] next_write_ptr;
reg [5:0] next_read_ptr;

assign empty = (count == 0);
assign full = (count == 64);
assign data_out = mem[read_ptr];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        write_ptr <= 0;
        read_ptr <= 0;
        count <= 0;
    end else begin
        if (wr_en && !full) begin
            mem[write_ptr] <= data_in;
            next_write_ptr <= write_ptr + 1;
            count <= count + 1;
        end else begin
            next_write_ptr <= write_ptr;
        end
        
        if (rd_en && !empty) begin
            next_read_ptr <= read_ptr + 1;
            count <= count - 1;
        end else begin
            next_read_ptr <= read_ptr;
        end
        
        write_ptr <= next_write_ptr;
        read_ptr <= next_read_ptr;
    end
end

endmodule
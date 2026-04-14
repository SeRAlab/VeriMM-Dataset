module top_module(
    input clk,
    input clk7_en,
    input reset,
    input [15:0] data_in,
    input rd,
    input wr,
    output reg [15:0] data_out,
    output reg full,
    output reg empty,
    output reg last
);reg [15:0] mem [4095:0];
reg [12:0] inptr;
reg [12:0] outptr;
wire empty_rd;
reg empty_wr;

always @(posedge clk) begin
    if (reset) begin
        inptr <= 12'd0;
    end else if (wr && clk7_en) begin
        mem[inptr] <= data_in;
        inptr <= inptr + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        outptr <= 13'd0;
    end else if (rd && clk7_en) begin
        data_out <= mem[outptr];
        outptr <= outptr + 1;
    end
end

assign empty_rd = inptr == outptr;
always @(posedge clk) begin
    if (clk7_en) begin
        empty_wr <= empty_rd;
    end
end

assign empty = empty_rd | empty_wr;

assign full = inptr[12:8] != outptr[12:8];
assign last = outptr[7:0] == 8'hFF;

endmodule
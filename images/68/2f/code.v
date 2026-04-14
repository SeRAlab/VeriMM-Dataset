module top_module(
    dout,
    wr_clk,
    rd_clk,
    I1,
    tmp_ram_rd_en,
    Q,
    O2,
    O1,
    din
);parameter WIDTH = 64;
parameter DEPTH = 16;

input wr_clk;
input rd_clk;
input I1;
input tmp_ram_rd_en;
input [0:0]Q;
input [11:0]O2;
input [11:0]O1;
input [WIDTH-1:0]din;

output [WIDTH-1:0]dout;

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [4:0] wr_ptr;
reg [4:0] rd_ptr;
reg [4:0] count;
reg [WIDTH-1:0] read_data;

assign dout = read_data;

always @(posedge wr_clk) begin
    if (I1 && count < DEPTH) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
    end
end

always @(posedge rd_clk) begin
    if (tmp_ram_rd_en && count > 0) begin
        read_data <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
    end
end

assign Q = (count == 0);

endmodule
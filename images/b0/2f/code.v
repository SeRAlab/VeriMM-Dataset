module top_module(
    byteena_a,
    clock,
    data,
    rdaddress,
    wraddress,
    wren,
    q
);parameter DATA_WIDTH = 64;
parameter ADDR_WIDTH = 8;
parameter MEM_DEPTH = 256;

input [ADDR_WIDTH-1:0] rdaddress;
input [ADDR_WIDTH-1:0] wraddress;
input [DATA_WIDTH-1:0] data;
input [7:0] byteena_a;
input wren;
input clock;

output [DATA_WIDTH-1:0] q;

reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
reg [DATA_WIDTH-1:0] q_reg;

assign q = q_reg;

always @(posedge clock) begin
    if (wren) begin
        // Updating only the bytes specified by byteena_a
        if (byteena_a[0]) mem[wraddress][7:0] <= data[7:0];
        if (byteena_a[1]) mem[wraddress][15:8] <= data[15:8];
        if (byteena_a[2]) mem[wraddress][23:16] <= data[23:16];
        if (byteena_a[3]) mem[wraddress][31:24] <= data[31:24];
        if (byteena_a[4]) mem[wraddress][39:32] <= data[39:32];
        if (byteena_a[5]) mem[wraddress][47:40] <= data[47:40];
        if (byteena_a[6]) mem[wraddress][55:48] <= data[55:48];
        if (byteena_a[7]) mem[wraddress][63:56] <= data[63:56];
    end
    // Read operation outside the wren condition to preserve the last read output
    q_reg <= mem[rdaddress];
end

endmodule
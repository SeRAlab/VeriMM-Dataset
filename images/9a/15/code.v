module dual_port_ram_simple#(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input wire wclk,
    input wire rclk,
    input wire wen,
    input wire ren,
    input wire [$clog2(DEPTH)-1:0] waddr,
    input wire [$clog2(DEPTH)-1:0] raddr,
    input wire [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram [0:DEPTH-1];

always @(posedge wclk) begin
    if (wen) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (ren) begin
        rdata <= ram[raddr];
    end
end

endmodule
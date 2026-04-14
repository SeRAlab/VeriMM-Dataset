module dual_port_ram(
    input        clk,
    input        wr_en,
    input  [7:0] wr_addr,
    input  [7:0] rd_addr,
    input  [7:0] data_in,
    output [7:0] data_out
);
reg [7:0] mem [255:0];

// Write logic
always @(posedge clk) begin
    if (wr_en)
        mem[wr_addr] <= data_in;
end

// Asynchronous read logic
assign data_out = mem[rd_addr];

endmodule
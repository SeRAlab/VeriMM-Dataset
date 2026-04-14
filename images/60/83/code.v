module top_module(
    input clk,
    input [23:0] data_in,
    input [9:0] write_addr,
    input [9:0] read_addr,
    input write_en,
    output reg [23:0] data_out
);reg [23:0] mem [0:1023];

always @(posedge clk) begin
    if (write_en) begin
        mem[write_addr] <= data_in;
    end
    data_out <= mem[read_addr];
end

endmodule
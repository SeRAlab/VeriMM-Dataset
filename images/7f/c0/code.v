module ram_8x16_sync(
    input clk,
    input wr_en,
    input [3:0] addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);

reg [7:0] memory [15:0];

always @(posedge clk) begin
    if (wr_en) begin
        memory[addr] <= data_in;
    end else begin
        data_out <= memory[addr];
    end
end

endmodule
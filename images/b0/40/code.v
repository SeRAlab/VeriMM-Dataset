module dual_port_ram
(
    input clk,
    input we,
    input [7:0] w_addr,
    input [15:0] w_data,
    input [7:0] r_addr,
    output reg [15:0] r_data
);

reg [15:0] mem [255:0];

always @(posedge clk) begin
    if (we) begin
        mem[w_addr] <= w_data;
    end
    r_data <= mem[r_addr];
end

endmodule
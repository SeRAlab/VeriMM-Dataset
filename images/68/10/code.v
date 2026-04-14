module reg_file(
    input  clk,
    input  we,
    input  [1:0] addr_w,
    input  [1:0] addr_r1,
    input  [1:0] addr_r2,
    input  [7:0] data_in,
    output [7:0] data_out1,
    output [7:0] data_out2
);

reg [7:0] registers [3:0];

always @(posedge clk) begin
    if (we) begin
        registers[addr_w] <= data_in;
    end
end

assign data_out1 = registers[addr_r1];
assign data_out2 = registers[addr_r2];

endmodule
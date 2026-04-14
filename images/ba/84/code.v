module top_module(
    input clk1, clk2, we1, we2, oe1, oe2,
    input [10:0] addr1, addr2,
    input [39:0] data1, data2,
    output reg [39:0] q1, q2  // Changed wire to reg
);reg [39:0] ram[0:4095];

always @(posedge clk1) begin
    if (we1) begin
        ram[addr1] <= data1;
    end
    if (oe1) begin
        q1 <= ram[addr1];
    end
end

always @(posedge clk2) begin
    if (we2) begin
        ram[addr2] <= data2;
    end
    if (oe2) begin
        q2 <= ram[addr2];
    end
end

endmodule
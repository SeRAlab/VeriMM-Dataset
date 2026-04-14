module register_file(
    input clk,
    input we1, we2,
    input [3:0] waddr1, waddr2,
    input [15:0] wdata1, wdata2,
    input [3:0] raddr1, raddr2, raddr3, raddr4,

    output reg [15:0] rdata1, rdata2, rdata3, rdata4
);
    reg [15:0] registers [15:0];

    always @(posedge clk) begin
        if (we1) begin
            registers[waddr1] <= wdata1;
        end
        if (we2) begin
            registers[waddr2] <= wdata2;
        end
    end

    always @(*) begin
        rdata1 = registers[raddr1];
        rdata2 = registers[raddr2];
        rdata3 = registers[raddr3];
        rdata4 = registers[raddr4];
    end
endmodule
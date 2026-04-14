module top_module(
    input [3:0] DI,
    input [3:0] AD,
    input CLK,
    input WRE,
    output reg [3:0] DO
);parameter WIDTH  = 4;
parameter INIT_0 = 16'h0000;
parameter INIT_1 = 16'h0000;
parameter INIT_2 = 16'h0000;
parameter INIT_3 = 16'h0000;

reg [15:0] mem[0:3];

integer i;

initial begin
    mem[0] = INIT_0;
    mem[1] = INIT_1;
    mem[2] = INIT_2;
    mem[3] = INIT_3;
end

always @(posedge CLK) begin
    if (WRE) begin
        mem[0][AD] <= DI[0];
        mem[1][AD] <= DI[1];
        mem[2][AD] <= DI[2];
        mem[3][AD] <= DI[3];
    end
end

always @(negedge CLK) begin
    DO <= {mem[0][AD], mem[1][AD], mem[2][AD], mem[3][AD]};
end

endmodule
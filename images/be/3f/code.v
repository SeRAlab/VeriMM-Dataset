module top_module(
    input clk,
    input we1,
    input we2,
    input [17:0] data1,
    input [17:0] data2,
    input [15:0] addr1,
    input [15:0] addr2,
    output reg [17:0] out1,
    output reg [17:0] out2
);reg [17:0] mem [0:65535];

    always @(posedge clk) begin
        if (we1) begin
            mem[addr1] <= data1;
        end
        if (we2 && !we1) begin
            mem[addr2] <= data2;
        end
        out1 <= mem[addr1];
        out2 <= mem[addr2];
    end

endmodule
module top_module(
    input clk,
    input reset,
    input [7:0] address0,
    input ce0,
    output reg [7:0] q0,
    input [7:0] address1,
    input ce1,
    output reg [7:0] q1,
    input [7:0] address2,
    input ce2,
    output reg [7:0] q2
);parameter DataWidth = 8;
parameter AddressRange = 256;

reg [DataWidth-1:0] rom0 [AddressRange-1:0];
reg [DataWidth-1:0] rom1 [AddressRange-1:0];
reg [DataWidth-1:0] rom2 [AddressRange-1:0];

integer i;

always @(posedge clk) begin
    if (reset) begin
        // reset all memory banks to 0
        for (i = 0; i < AddressRange; i = i + 1) begin
            rom0[i] <= 8'b0;
            rom1[i] <= 8'b0;
            rom2[i] <= 8'b0;
        end
    end else begin
        // read data from memory banks based on address and chip enable signals
        if (ce0) begin
            q0 <= rom0[address0];
        end
        if (ce1) begin
            q1 <= rom1[address1];
        end
        if (ce2) begin
            q2 <= rom2[address2];
        end
    end
end

// initialize memory banks with default values
initial begin
    for (i = 0; i < AddressRange; i = i + 1) begin
        rom0[i] = 8'b0;
        rom1[i] = 8'b0;
        rom2[i] = 8'b0;
    end
end

endmodule
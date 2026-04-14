module top_module(
    input [2:0] BIN,
    input CLK,
    output reg [2:0] GRAY
);always @(posedge CLK) begin
    GRAY[2] <= BIN[2];
    GRAY[1] <= BIN[2] ^ BIN[1];
    GRAY[0] <= BIN[1] ^ BIN[0];
end

endmodule
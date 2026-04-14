module counter_3bit_sync_reset(
    input wire CLK,
    input wire RST,
    output reg [2:0] Q
    );

always @(posedge CLK) begin
    if (RST) begin
        Q <= 3'b000;
    end else begin
        Q <= Q + 1;
    end
end

endmodule
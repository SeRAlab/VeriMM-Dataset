module dff_async_reset(
    input wire [7:0] D,
    input wire CLK,
    input wire RST,
    output reg [7:0] Q
    );

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 8'b0;
    end else begin
        Q <= D;
    end
end

endmodule
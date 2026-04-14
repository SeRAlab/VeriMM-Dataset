module sync_register(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 16'b0;
    end else if (enable) begin
        q <= d;
    end
end

endmodule
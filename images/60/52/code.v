module register8bit (
    input wire [7:0] d,
    input wire clk,
    input wire rst,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 8'b00000000;
    end else begin
        q <= d;
    end
end

endmodule
module Register8Bit (
    input wire clk,
    input wire rst,
    input wire clk_en,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'b0;
    end else if (clk_en) begin
        q <= d;
    end
end

endmodule
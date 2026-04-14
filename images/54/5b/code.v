module register(
    input wire clk,
    input wire clr_n,
    input wire en,
    input wire [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or negedge clr_n) begin
    if (!clr_n) begin
        q <= 8'b00000000;
    end else if (en) begin
        q <= d;
    end
end

endmodule
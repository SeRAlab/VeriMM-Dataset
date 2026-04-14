module shift_register_8bit(
    input wire clk,
    input wire reset,
    output reg [7:0] q
    );

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 8'b00000000;
    end else begin
        q <= q << 1;
    end
end

endmodule
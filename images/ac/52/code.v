module shift_register(
    input           clk,
    input           reset,
    input           shift_in,

    output reg [7:0] out
);

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        out <= 8'b00000000;
    end else begin
        out <= {shift_in, out[7:1]};
    end
end

endmodule
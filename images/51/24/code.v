module shift_register_4bit(
    input wire clk,
    input wire load,
    input wire [3:0] in,
    output reg out
    );

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= in;
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b0};
    end
end

always @(posedge clk) begin
    out <= shift_reg[3];
end

endmodule
module top_module(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);reg [7:0] shift_reg;
reg [2:0] counter;

always @(posedge clk) begin
    if (counter == 3'b111) begin
        counter <= 3'b000;
        shift_reg <= {shift_reg[6:0], d};
    end
    else begin
        counter <= counter + 1;
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

always @(posedge clk) begin
    if (counter == 3'b111) begin
        q <= shift_reg ^ d;
    end
end

endmodule
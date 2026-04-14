module top_module(
    input clk,
    input [7:0] data,
    output reg [2:0] LED
);reg [7:0] shift_reg;
reg [2:0] counter;

always @(posedge clk) begin
    shift_reg <= {shift_reg[6:0], data};
    counter <= counter + 1;
    if (counter == 7) begin
        counter <= 0;
        LED <= {shift_reg[7], shift_reg[3], shift_reg[0]};
    end
end

endmodule
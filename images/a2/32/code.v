module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input load,
    input ena,
    input [3:0] data,
    output [7:0] q
);reg [3:0] counter;
reg [3:0] shift_reg;
reg [3:0] shift_reg_next;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0;
        shift_reg <= 4'b0;
    end else begin
        counter <= counter + 1;
        shift_reg <= ena ? shift_reg_next : shift_reg;
    end
end

always @(*) begin
    case (load)
        1'b0: shift_reg_next = {shift_reg[2:0], data};
        1'b1: shift_reg_next = data;
    endcase
end

assign q = {counter, shift_reg} + 8'b0;

endmodule
module top_module(
    input shift_left,
    input shift_right,
    input parallel_load,
    input [3:0] data_in,
    output [3:0] out
);reg [3:0] shift_reg;

always @ (shift_left or shift_right or parallel_load or data_in) begin
    if (parallel_load) begin
        shift_reg <= data_in;
    end else if (shift_left) begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]}; // Shift left
    end else if (shift_right) begin
        shift_reg <= {shift_reg[0], shift_reg[3:1]}; // Shift right (corrected part select)
    end
end
    
assign out = shift_reg;

endmodule
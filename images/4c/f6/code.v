module top_module(
    input clk,
    input reset,
    input [2:0] vec,
    input serial_in,
    output reg [2:0] final_output
);reg [2:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b000;
    end else begin
        shift_reg <= {shift_reg[1:0], serial_in};
    end
end

assign final_output = shift_reg & vec;

endmodule
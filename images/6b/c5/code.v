module top_module(
    input CLK,
    input SHIFT,
    input LOAD,
    input [15:0] DATA_IN,
    input mode,
    output reg [15:0] DATA_OUT
);reg [15:0] shift_reg;

always @(posedge CLK) begin
    if (LOAD) begin
        shift_reg <= DATA_IN;
    end else if (SHIFT) begin
        if (mode) begin
            shift_reg <= {shift_reg[14:0], 1'b0};
        end else begin
            shift_reg <= {shift_reg[14:0], 1'b1};
        end
    end
end

assign DATA_OUT = shift_reg;

endmodule
module top_module(
    input CLK, LOAD,
    input [7:0] DATA_IN,
    output [7:0] Q,
    output Q7
);reg [7:0] shift_reg;

always @(posedge CLK) begin
    if (LOAD) begin
        shift_reg <= DATA_IN;
    end else begin
        shift_reg <= {shift_reg[6:0], Q7};
    end
end

assign Q = shift_reg;
assign Q7 = shift_reg[7];

endmodule
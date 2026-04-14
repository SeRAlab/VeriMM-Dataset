module top_module(
    input CLK,
    input DIN,
    input LOAD,
    output reg [3:0] Q,
    output reg [3:0] QBAR
);parameter WIDTH = 4;

reg [WIDTH-1:0] shift_reg;

always @(posedge CLK) begin
    if (LOAD) begin
        shift_reg <= DIN;
    end else begin
        shift_reg <= {shift_reg[WIDTH-2:0], DIN};
    end
end

assign Q = shift_reg;
assign QBAR = ~shift_reg;

endmodule
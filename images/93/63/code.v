module top_module(
    input [3:0] data_in,
    input load,
    input shift,
    output [3:0] out
);reg [3:0] shift_reg;

always @ (posedge shift) begin
    shift_reg <= {shift_reg[2:0], data_in};
end

always @ (posedge load) begin
    if (load) begin
        shift_reg <= data_in;
    end
end

assign out = shift_reg;

endmodule
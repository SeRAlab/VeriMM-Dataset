module top_module(
    input [3:0] binary,
    output reg [3:0] twos_comp
);reg [3:0] invert;
reg [3:0] add_one;

always @ (binary) begin
    invert <= ~binary;
end

always @ (invert) begin
    add_one <= invert + 4'b0001;
end

assign twos_comp = add_one;

endmodule
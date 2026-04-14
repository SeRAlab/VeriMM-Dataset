module top_module(
    input [3:0] binary,
    output reg [3:0] square
);always @ (binary) begin
    square <= binary * binary;
end

endmodule
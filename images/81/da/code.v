module top_module(
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] shifted_in;
reg [2:0] binary_search;

always @(*) begin
    shifted_in = in;
    binary_search = 3'b000;

    if (shifted_in[7:4] != 4'b0000) begin
        binary_search[2] = 1'b1;
        shifted_in = shifted_in >> 4;
    end

    if (shifted_in[7:6] != 2'b00) begin
        binary_search[1] = 1'b1;
        shifted_in = shifted_in >> 2;
    end

    if (shifted_in[7] != 1'b0) begin
        binary_search[0] = 1'b1;
    end

    pos = binary_search;
end

endmodule
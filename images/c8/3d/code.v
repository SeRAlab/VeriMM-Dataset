module Adder(
    input [2:0] A,
    input [2:0] B,
    input CLK,
    input RST,
    output reg [2:0] Q
);

always @(posedge CLK) begin
    if (RST) begin
        Q <= 3'b0;
    end else begin
        Q <= A + B;
    end
end

endmodule
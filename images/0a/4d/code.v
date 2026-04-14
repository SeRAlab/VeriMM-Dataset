module mux32to1 (
    input [31:0] in,        // 32 input lines
    input [4:0] select,     // 5-bit select line
    output reg out          // Output line
);

always @(*) begin
    out = in[select];       // Select the output based on the select input
end

endmodule
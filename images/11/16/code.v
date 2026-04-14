module decoder4to16 (
    input [3:0] a,
    output reg [15:0] o
);

always @(*) begin
    o = 16'b0; // Initialize all outputs to 0
    o[a] = 1'b1; // Set the output corresponding to the input value
end

endmodule
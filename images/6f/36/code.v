module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] OUT  // Change 'output' to 'output reg'
);always @(*) begin
        OUT = (A >= B) ? (A - B) : (B - A);
    end

endmodule
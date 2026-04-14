module top_module(
    input [7:0] A,
    input [7:0] B,
    input C,
    output reg [7:0] Sum,
    output reg [7:0] Difference
);always @(*) begin
    if(C) begin
        // Perform addition
        Sum = A + B;
        Difference = 0;
    end else begin
        // Perform subtraction
        Difference = A - B;
        Sum = 0;
    end
end

endmodule
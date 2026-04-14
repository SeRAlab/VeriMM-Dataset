module top_module(
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result
);integer i; // Declare the index variable 'i'

always @(*) begin
    result = 0;
    for (i = 0; i < 8; i = i + 1) begin
        if (a[i] == 1) begin
            result = result + (b << i);
        end
    end
end

endmodule
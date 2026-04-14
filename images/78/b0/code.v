module top_module(
    input [3:0] in_0,
    input [4:0] in_1, // Adjusted to match the bit-width after concat with ctrl
    input ctrl,
    output reg [3:0] result
);always @(*) begin
        if (ctrl == 0) begin
            result = in_0 + in_1[3:0]; // Perform addition when ctrl is 0
        end else begin
            result = in_0 - in_1[3:0]; // Perform subtraction when ctrl is 1
        end
    end
endmodule
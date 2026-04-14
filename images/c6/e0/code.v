module binary_to_gray(
    input [3:0] binary,
    input clk,
    output reg [3:0] gray
);

    always @(posedge clk) begin
        gray <= binary ^ (binary >> 1);
    end

endmodule
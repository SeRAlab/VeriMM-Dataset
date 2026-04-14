module subtractor_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] diff
);

    always @(*) begin
        if (reset) begin
            diff = 0;
        end else if (enable) begin
            diff = a - b;
        end else begin
            diff = diff; // Maintain the current value
        end
    end
endmodule
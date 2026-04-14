module nor_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] nor_result
);

    always @(*) begin
        if (reset) begin
            nor_result = 0;
        end else if (enable) begin
            nor_result = ~(a | b);
        end else begin
            nor_result = nor_result; // Maintain the current value
        end
    end
endmodule
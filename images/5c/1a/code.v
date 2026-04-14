module top_module (
    input [2:0] binary_in,
    output reg [7:0] one_hot_out
);

    always @(*) begin
        one_hot_out = 8'd0; // Initialize to 0
        one_hot_out[binary_in] = 1'b1; // Set the corresponding bit to 1
    end

endmodule
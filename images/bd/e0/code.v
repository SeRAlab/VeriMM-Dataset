module top_module(
    input [3:0] binary_in,
    input select,
    output reg [3:0] gray_out  // Change from wire to reg
);always @ (select or binary_in) begin
        if (select == 1'b1) begin
            gray_out[0] <= binary_in[0];
            gray_out[1] <= binary_in[0] ^ binary_in[1];
            gray_out[2] <= binary_in[1] ^ binary_in[2];
            gray_out[3] <= binary_in[2] ^ binary_in[3];
        end else begin
            gray_out <= binary_in;  // Assign binary_in directly to gray_out
        end
    end

endmodule
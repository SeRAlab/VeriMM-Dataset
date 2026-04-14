module top_module(
    input  wire        rst,
    input  wire  [3:0] bin_in,
    output reg   [3:0] gray_out
);/* Combinational logic to convert binary to gray code */
    always @* begin
        gray_out[0] = bin_in[0];
        gray_out[1] = bin_in[0] ^ bin_in[1];
        gray_out[2] = bin_in[1] ^ bin_in[2];
        gray_out[3] = bin_in[2] ^ bin_in[3];
    end

    /* Reset logic */
    always @(posedge rst) begin
        gray_out <= 4'b0;
    end

endmodule
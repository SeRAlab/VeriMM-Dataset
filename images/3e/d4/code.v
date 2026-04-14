module parity_checker (
    input [3:0] data_in,
    output reg parity_out
);
    always @(*) begin
        // Count the number of '1's in the input
        parity_out = ~(data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3]);
    end
endmodule
module decoder_5to32 (
    input [4:0] addr,
    output reg [31:0] out
);
    always @(*) begin
        out = 32'b0; // Initialize output to 0
        out[addr] = 1'b1; // Set the output corresponding to the input address
    end
endmodule
module address_decoder(
    input [31:0] address,
    output reg [3:0] region
);
    always @(*) begin
        case (address)
            32'h00000000: region = 4'b0001; // Region 0
            32'h40000000: region = 4'b0010; // Region 1
            32'h80000000: region = 4'b0100; // Region 2
            32'hC0000000: region = 4'b1000; // Region 3
            default: region = 4'b0000; // No region
        endcase
    end
endmodule
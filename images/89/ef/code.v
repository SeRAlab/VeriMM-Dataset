module binary_decoder (
    input wire en,
    input wire [1:0] bin_in,
    output reg [3:0] dec_out
);

always @(*)
begin
    if (en)
        case (bin_in)
            2'b00: dec_out = 4'b0001;
            2'b01: dec_out = 4'b0010;
            2'b10: dec_out = 4'b0100;
            2'b11: dec_out = 4'b1000;
            default: dec_out = 4'b0000;
        endcase
    else
        dec_out = 4'b0000;
end

endmodule
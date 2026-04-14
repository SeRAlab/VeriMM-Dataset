module dac_8bit (
    input [7:0] din,
    input valid,
    output reg [7:0] dout
);
    always @* begin
        if (valid) begin
            dout = din; // Output follows the input when valid
        end else begin
            dout = 8'b00000000; // Output zero when not valid
        end
    end
endmodule
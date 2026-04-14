module wifi_strength_decoder(
    input [4:0] signal_strength,
    output reg [1:0] strength_code
);
    always @(*) begin
        if (signal_strength <= 5'b01010) // 0 to 10
            strength_code = 2'b00; // weak
        else if (signal_strength <= 5'b10100) // 11 to 20
            strength_code = 2'b01; // moderate
        else
            strength_code = 2'b10; // strong
    end
endmodule
module priority_encoder_4bit (
    input [3:0] in,
    output reg [1:0] binary_out,
    output reg valid
);

    always @(*) begin
        valid = 1;
        casez (in)
            4'b1???: binary_out = 2'b11;
            4'b01??: binary_out = 2'b10;
            4'b001?: binary_out = 2'b01;
            4'b0001: binary_out = 2'b00;
            default: begin
                binary_out = 2'b00;
                valid = 0;
            end
        endcase
    end

endmodule
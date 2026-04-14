module priority_encoder_4bit(
    input wire [3:0] a,
    output reg [1:0] y,
    output reg valid
);

    always @(*) begin
        valid = 1;
        casez (a)
            4'b1???: y = 2'b11;
            4'b01??: y = 2'b10;
            4'b001?: y = 2'b01;
            4'b0001: y = 2'b00;
            default: begin
                y = 2'b00;
                valid = 0;
            end
        endcase
    end

endmodule
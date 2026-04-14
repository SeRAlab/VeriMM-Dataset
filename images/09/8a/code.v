module priority_encoder(
    input [7:0] I,
    output reg [2:0] Y,
    output reg valid
);
    always @(*) begin
        case (1'b1)
            I[0]: begin Y = 3'b000; valid = 1; end
            I[1]: begin Y = 3'b001; valid = 1; end
            I[2]: begin Y = 3'b010; valid = 1; end
            I[3]: begin Y = 3'b011; valid = 1; end
            I[4]: begin Y = 3'b100; valid = 1; end
            I[5]: begin Y = 3'b101; valid = 1; end
            I[6]: begin Y = 3'b110; valid = 1; end
            I[7]: begin Y = 3'b111; valid = 1; end
            default: begin Y = 3'b111; valid = 0; end
        endcase
    end
endmodule
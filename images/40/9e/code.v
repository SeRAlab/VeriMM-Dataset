module encoder_8_to_3 (
    input [7:0] I,
    output reg [2:0] O,
    output reg valid
);
    always @(*) begin
        valid = 0;
        O = 3'b000; // Default output
        if (I[7]) begin
            O = 3'b111;
            valid = 1;
        end else if (I[6]) begin
            O = 3'b110;
            valid = 1;
        end else if (I[5]) begin
            O = 3'b101;
            valid = 1;
        end else if (I[4]) begin
            O = 3'b100;
            valid = 1;
        end else if (I[3]) begin
            O = 3'b011;
            valid = 1;
        end else if (I[2]) begin
            O = 3'b010;
            valid = 1;
        end else if (I[1]) begin
            O = 3'b001;
            valid = 1;
        end else if (I[0]) begin
            O = 3'b000;
            valid = 1;
        end
    end
endmodule
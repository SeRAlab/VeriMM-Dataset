module priority_encoder (
    input [3:0] I,
    output reg [1:0] Y,
    output reg valid
);
    always @(*) begin
        casez (I)
            4'b1???: begin
                Y = 2'b11; // I3 is highest priority
                valid = 1;
            end
            4'b01??: begin
                Y = 2'b10; // I2 is highest priority
                valid = 1;
            end
            4'b001?: begin
                Y = 2'b01; // I1 is highest priority
                valid = 1;
            end
            4'b0001: begin
                Y = 2'b00; // I0 is highest priority
                valid = 1;
            end
            default: begin
                Y = 2'b00; // No input is active
                valid = 0;
            end
        endcase
    end
endmodule
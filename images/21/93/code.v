module priority_encoder (
    input [3:0] I, // 4 input lines
    output reg [1:0] Y, // 2 output lines
    output reg valid // indicates if any input is active
);
    always @(*) begin
        case (I)
            4'b0000: begin
                Y = 2'b00;
                valid = 0;
            end
            4'b0001: begin
                Y = 2'b00;
                valid = 1;
            end
            4'b0010: begin
                Y = 2'b01;
                valid = 1;
            end
            4'b0100: begin
                Y = 2'b10;
                valid = 1;
            end
            4'b1000: begin
                Y = 2'b11;
                valid = 1;
            end
            4'b0011: begin
                Y = 2'b01; // I2 or I1
                valid = 1;
            end
            4'b0111: begin
                Y = 2'b10; // I3 or I1 or I2
                valid = 1;
            end
            4'b1111: begin
                Y = 2'b11; // I3 or I2 or I1
                valid = 1;
            end
            default: begin
                Y = 2'b00; // Default case
                valid = 0;
            end
        endcase
    end
endmodule
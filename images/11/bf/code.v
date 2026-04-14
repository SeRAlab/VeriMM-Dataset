module encoder_4to2 (
    input wire I0,
    input wire I1,
    input wire I2,
    input wire I3,
    output reg Y1,
    output reg Y0
);
    always @(*) begin
        case ({I3, I2, I1, I0})
            4'b0000: begin
                Y1 = 0;
                Y0 = 0;
            end
            4'b0001: begin
                Y1 = 0;
                Y0 = 0;
            end
            4'b0010: begin
                Y1 = 0;
                Y0 = 1;
            end
            4'b0011: begin
                Y1 = 0;
                Y0 = 1;
            end
            4'b0100: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b0101: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b0110: begin
                Y1 = 1;
                Y0 = 1;
            end
            4'b0111: begin
                Y1 = 1;
                Y0 = 1;
            end
            4'b1000: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b1001: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b1010: begin
                Y1 = 1;
                Y0 = 1;
            end
            4'b1011: begin
                Y1 = 1;
                Y0 = 1;
            end
            4'b1100: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b1101: begin
                Y1 = 1;
                Y0 = 0;
            end
            4'b1110: begin
                Y1 = 1;
                Y0 = 1;
            end
            4'b1111: begin
                Y1 = 1;
                Y0 = 1;
            end
            default: begin
                Y1 = 0;
                Y0 = 0;
            end
        endcase
    end
endmodule
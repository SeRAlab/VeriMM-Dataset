module priority_encoder_3bit (D, Y, VALID);
input [2:0] D;
output reg [1:0] Y;
output reg VALID;

always @(*) begin
    if (D[2]) begin
        Y = 2'b10;
        VALID = 1'b1;
    end
    else if (D[1]) begin
        Y = 2'b01;
        VALID = 1'b1;
    end
    else if (D[0]) begin
        Y = 2'b00;
        VALID = 1'b1;
    end
    else begin
        Y = 2'b00;
        VALID = 1'b0;
    end
end

endmodule
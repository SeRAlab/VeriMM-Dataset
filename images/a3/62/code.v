module priority_encoder_8bit
(
    input [7:0] i,
    output reg [2:0] y,
    output reg valid
);

always @(*) begin
    valid = |i;
    if (i[7]) y = 3'b111;
    else if (i[6]) y = 3'b110;
    else if (i[5]) y = 3'b101;
    else if (i[4]) y = 3'b100;
    else if (i[3]) y = 3'b011;
    else if (i[2]) y = 3'b010;
    else if (i[1]) y = 3'b001;
    else if (i[0]) y = 3'b000;
    else y = 3'b000;
end

endmodule
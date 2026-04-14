module priority_encoder(
    input [3:0] in,
    output reg [1:0] out,
    output reg valid);
always @(*) begin
    if (in[3]) begin
        out = 2'b11;
        valid = 1'b1;
    end else if (in[2]) begin
        out = 2'b10;
        valid = 1'b1;
    end else if (in[1]) begin
        out = 2'b01;
        valid = 1'b1;
    end else if (in[0]) begin
        out = 2'b00;
        valid = 1'b1;
    end else begin
        out = 2'b00;
        valid = 1'b0;
    end
end
endmodule
module priority_encoder_4bit (D, Y, V);
input [3:0] D;
output reg [1:0] Y;
output reg V;

always @(*) begin
    if (D[3]) begin
        Y = 2'b11;
        V = 1'b1;
    end
    else if (D[2]) begin
        Y = 2'b10;
        V = 1'b1;
    end
    else if (D[1]) begin
        Y = 2'b01;
        V = 1'b1;
    end
    else if (D[0]) begin
        Y = 2'b00;
        V = 1'b1;
    end
    else begin
        Y = 2'b00;
        V = 1'b0;
    end
end

endmodule
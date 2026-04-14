module bitwise_xor(input [7:0] A, input [7:0] B, input C, output reg [7:0] Y);

always @(*) begin
    if(C) begin
        Y = A ^ B;
    end
    else begin
        Y = A;
    end
end

endmodule
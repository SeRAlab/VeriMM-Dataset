module top_module(
    input [7:0] I,
    input EN,
    output reg [2:0] Y
);always @ (I or EN) begin
    if (EN == 1'b1) begin
        if (I[7] == 1'b1) Y[0] = 3'b111;
        else if (I[6] == 1'b1) Y[0] = 3'b110;
        else if (I[5] == 1'b1) Y[0] = 3'b101;
        else if (I[4] == 1'b1) Y[0] = 3'b100;
        else if (I[3] == 1'b1) Y[0] = 3'b011;
        else if (I[2] == 1'b1) Y[0] = 3'b010;
        else if (I[1] == 1'b1) Y[0] = 3'b001;
        else if (I[0] == 1'b1) Y[0] = 3'b000;
    end else begin
        Y[0] = 3'b000;
    end

    if (|I) begin
        Y[1] = 1'b1;
    end else begin
        Y[1] = 1'b0;
    end

    if (~|I) begin
        Y[2] = 1'b1;
    end else begin
        Y[2] = 1'b0;
    end
end

endmodule
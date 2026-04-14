module priority_encoder (
    input A1,
    input A2,
    input A3,
    input A4,
    output reg [1:0] X
);

always @* begin
    if (A4) begin
        X = 2'b11;
    end else if (A3) begin
        X = 2'b10;
    end else if (A2) begin
        X = 2'b01;
    end else if (A1) begin
        X = 2'b00;
    end else begin
        X = 2'b00;
    end
end

endmodule
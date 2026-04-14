module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    output reg [1:0] Y
);always @* begin
    if (A1 == 0 && A2 == 0) begin
        Y = 2'b00;
    end else if (A1 == 1 && A2 == 1) begin
        Y = 2'b01;
    end else if (B1 == 1 && C1 == 0) begin
        Y = 2'b10;
    end else if (B1 == 0 && C1 == 1) begin
        Y = 2'b11;
    end
end

endmodule
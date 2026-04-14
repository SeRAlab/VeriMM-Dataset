module priority_arbiter(
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);

always @(*) begin
    if (req0) begin
        grant = 2'b00; // grant req0
    end else if (req1) begin
        grant = 2'b01; // grant req1
    end else if (req2) begin
        grant = 2'b10; // grant req2
    end else if (req3) begin
        grant = 2'b11; // grant req3
    end else begin
        grant = 2'bxx; // no request
    end
end

endmodule
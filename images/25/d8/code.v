module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    output reg [1:0] grant
);

always @(*) begin
    if (req0) begin
        grant = 2'b00; // Grant req0
    end else if (req1) begin
        grant = 2'b01; // Grant req1
    end else if (req2) begin
        grant = 2'b10; // Grant req2
    end else begin
        grant = 2'b11; // No request
    end
end

endmodule
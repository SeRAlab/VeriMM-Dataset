module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);

always @(*) begin
    if (req0)
        grant = 2'b00; // req0 granted
    else if (req1)
        grant = 2'b01; // req1 granted
    else if (req2)
        grant = 2'b10; // req2 granted
    else if (req3)
        grant = 2'b11; // req3 granted
    else
        grant = 2'bxx; // no grant
end

endmodule
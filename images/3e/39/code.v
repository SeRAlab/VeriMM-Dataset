module fixed_priority_arbiter(
    input wire req0,
    input wire req1,
    input wire req2,
    output reg [2:0] grant
);
    always @(*) begin
        if (req0) begin
            grant = 3'b001; // grant req0
        end else if (req1) begin
            grant = 3'b010; // grant req1
        end else if (req2) begin
            grant = 3'b100; // grant req2
        end else begin
            grant = 3'b000; // no request
        end
    end
endmodule
module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] grant
);
    always @(*) begin
        if (req0) grant = 2'b00; // Grant for req0
        else if (req1) grant = 2'b01; // Grant for req1
        else if (req2) grant = 2'b10; // Grant for req2
        else if (req3) grant = 2'b11; // Grant for req3
        else grant = 2'bxx; // No request
    end
endmodule
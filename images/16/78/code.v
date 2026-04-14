module priority_arbiter(
    input wire req0, 
    input wire req1, 
    input wire req2, 
    input wire req3, 
    output reg [3:0] grant
);
    always @(*) begin
        if (req0)
            grant = 4'b0001; // grant req0
        else if (req1)
            grant = 4'b0010; // grant req1
        else if (req2)
            grant = 4'b0100; // grant req2
        else if (req3)
            grant = 4'b1000; // grant req3
        else
            grant = 4'b0000; // no request
    end
endmodule
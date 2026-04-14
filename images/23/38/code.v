module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [1:0] granted
);
    always @(*) begin
        if (req0)
            granted = 2'b00; // grant request 0
        else if (req1)
            granted = 2'b01; // grant request 1
        else if (req2)
            granted = 2'b10; // grant request 2
        else if (req3)
            granted = 2'b11; // grant request 3
        else
            granted = 2'bxx; // no grant
    end
endmodule
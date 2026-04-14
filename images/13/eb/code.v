module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg [3:0] grant
);
    always @(*) begin
        // Default grant to no request
        grant = 4'b0000;

        // Grant based on priority
        if (req0) grant = 4'b0001; // Grant req0
        else if (req1) grant = 4'b0010; // Grant req1
        else if (req2) grant = 4'b0100; // Grant req2
        else if (req3) grant = 4'b1000; // Grant req3
    end
endmodule
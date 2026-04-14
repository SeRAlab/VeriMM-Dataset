module PriorityArbiter (
    input [4:0] req,
    output reg [4:0] grant
);
    always @(*) begin
        grant = 5'b00000; // Default: no grant
        if (req[0]) grant = 5'b00001; // Grant req[0] if requested
        else if (req[1]) grant = 5'b00010; // Grant req[1] if requested
        else if (req[2]) grant = 5'b00100; // Grant req[2] if requested
        else if (req[3]) grant = 5'b01000; // Grant req[3] if requested
        else if (req[4]) grant = 5'b10000; // Grant req[4] if requested
    end
endmodule
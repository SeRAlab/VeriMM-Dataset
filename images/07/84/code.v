module priority_arbiter (
    input  [3:0] req,
    output reg [3:0] grant
);
    always @(*) begin
        grant = 4'b0000; // Default no grant
        if (req[3]) grant[3] = 1'b1; // Grant to req[3]
        else if (req[2]) grant[2] = 1'b1; // Grant to req[2]
        else if (req[1]) grant[1] = 1'b1; // Grant to req[1]
        else if (req[0]) grant[0] = 1'b1; // Grant to req[0]
    end
endmodule
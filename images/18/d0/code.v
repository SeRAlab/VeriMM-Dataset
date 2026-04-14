module priority_arbiter (
    input wire clk,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk) begin
        grant <= 4'b0000; // Clear grants initially
        if (req[0]) grant[0] <= 1; // Grant to req0 if it is high
        else if (req[1]) grant[1] <= 1; // Grant to req1 if it is high
        else if (req[2]) grant[2] <= 1; // Grant to req2 if it is high
        else if (req[3]) grant[3] <= 1; // Grant to req3 if it is high
    end
endmodule
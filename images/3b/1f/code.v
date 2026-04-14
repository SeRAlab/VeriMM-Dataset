module FixedPriorityArbiter(
    input wire clk,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk) begin
        grant <= 4'b0000; // Default grant to none
        if (req[3]) grant <= 4'b1000; // Grant to req[3]
        else if (req[2]) grant <= 4'b0100; // Grant to req[2]
        else if (req[1]) grant <= 4'b0010; // Grant to req[1]
        else if (req[0]) grant <= 4'b0001; // Grant to req[0]
    end
endmodule
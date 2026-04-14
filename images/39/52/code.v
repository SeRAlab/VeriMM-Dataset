module fixed_priority_arbiter (
    input wire clk,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk) begin
        grant <= 4'b0000; // Reset grant
        if (req[3]) grant[3] <= 1; // Grant for highest priority
        else if (req[2]) grant[2] <= 1; // Grant for second highest
        else if (req[1]) grant[1] <= 1; // Grant for third highest
        else if (req[0]) grant[0] <= 1; // Grant for lowest priority
    end
endmodule
module round_robin_arbiter (
    input wire clk,
    input wire [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] pointer;

    always @(posedge clk) begin
        if (request != 4'b0000) begin
            grant <= 4'b0000; // Clear grants
            grant[pointer] <= 1'b1; // Grant to current pointer
            pointer <= (pointer + 1) % 4; // Move pointer in round-robin fashion
        end
    end
endmodule
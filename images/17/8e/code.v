module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] last_granted; // keeps track of the last granted requester

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000; // no grants on reset
            last_granted <= 2'b00; // start with the first requester
        end else begin
            // Round-robin grant logic
            if (request) begin
                last_granted = (last_granted + 1) % 4; // move to next requester
                grant = 4'b0000; // clear previous grants
                grant[last_granted] = request[last_granted]; // grant the current requester
            end else begin
                grant = 4'b0000; // no requests
            end
        end
    end
endmodule
module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [2:0] request, // 3 request lines
    output reg [2:0] grant     // 3 grant lines
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 3'b000; // No grants on reset
    end else begin
        // Default grant to no one
        grant <= 3'b000;
        // Grant highest priority request
        if (request[0]) grant <= 3'b001; // Grant to requester 0
        else if (request[1]) grant <= 3'b010; // Grant to requester 1
        else if (request[2]) grant <= 3'b100; // Grant to requester 2
    end
end

endmodule
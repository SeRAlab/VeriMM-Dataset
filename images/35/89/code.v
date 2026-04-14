module fixed_priority_arbiter(
    input wire clk,
    input wire reset,
    input wire [3:0] request, // 4 request lines
    output reg [3:0] grant    // 4 grant lines
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000; // No grant on reset
    end else begin
        grant <= 4'b0000; // Default no grant
        if (request[0]) grant <= 4'b0001; // Grant to request 0
        else if (request[1]) grant <= 4'b0010; // Grant to request 1
        else if (request[2]) grant <= 4'b0100; // Grant to request 2
        else if (request[3]) grant <= 4'b1000; // Grant to request 3
    end
end

endmodule
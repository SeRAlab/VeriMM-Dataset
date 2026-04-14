module fixed_priority_arbiter(
    input clk,
    input reset,
    input [3:0] request, // Request lines for A, B, C, D
    output reg [3:0] grant // Grant lines for A, B, C, D
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default no grant
            if (request[0]) grant <= 4'b0001; // Grant A
            else if (request[1]) grant <= 4'b0010; // Grant B
            else if (request[2]) grant <= 4'b0100; // Grant C
            else if (request[3]) grant <= 4'b1000; // Grant D
        end
    end
endmodule
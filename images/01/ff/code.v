module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] request,
    output reg [3:0] grant
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        grant <= 4'b0000;
    end else begin
        grant <= 4'b0000; // Default to no grants
        if (request[0]) grant <= 4'b0001; // Grant for Requester 0
        else if (request[1]) grant <= 4'b0010; // Grant for Requester 1
        else if (request[2]) grant <= 4'b0100; // Grant for Requester 2
        else if (request[3]) grant <= 4'b1000; // Grant for Requester 3
    end
end

endmodule
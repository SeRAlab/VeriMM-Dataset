module fixed_priority_arbiter (
    input clk,
    input reset,
    input [3:0] request,
    output reg [1:0] grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 2'b00;
        end else begin
            if (request[0]) grant <= 2'b00; // Grant to requestor 0
            else if (request[1]) grant <= 2'b01; // Grant to requestor 1
            else if (request[2]) grant <= 2'b10; // Grant to requestor 2
            else if (request[3]) grant <= 2'b11; // Grant to requestor 3
            else grant <= grant; // No request
        end
    end
endmodule
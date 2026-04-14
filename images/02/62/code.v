module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] request, // 4 request signals
    output reg [3:0] grant     // 4 grant signals
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Reset grant signals
            if (request[0]) grant[0] <= 1'b1; // Grant to requestor 0
            else if (request[1]) grant[1] <= 1'b1; // Grant to requestor 1
            else if (request[2]) grant[2] <= 1'b1; // Grant to requestor 2
            else if (request[3]) grant[3] <= 1'b1; // Grant to requestor 3
        end
    end

endmodule
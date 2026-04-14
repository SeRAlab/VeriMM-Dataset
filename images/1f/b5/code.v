module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] request,
    output reg [3:0] grant
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Reset the grant
            if (request[0]) grant <= 4'b0001; // Grant to Request 0
            else if (request[1]) grant <= 4'b0010; // Grant to Request 1
            else if (request[2]) grant <= 4'b0100; // Grant to Request 2
            else if (request[3]) grant <= 4'b1000; // Grant to Request 3
        end
    end
endmodule
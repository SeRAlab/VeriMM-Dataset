module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
        end else begin
            // Default grant to no requests
            grant <= 4'b0000;
            // Grant based on priority
            if (req[3]) grant <= 4'b1000; // Higher priority request
            else if (req[2]) grant <= 4'b0100;
            else if (req[1]) grant <= 4'b0010;
            else if (req[0]) grant <= 4'b0001;
        end
    end
endmodule
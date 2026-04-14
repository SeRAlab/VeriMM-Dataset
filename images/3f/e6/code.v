module priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 4'b0000; // Initialize grant to no request granted
        end else begin
            grant <= 4'b0000; // Default no grant
            if (req[0]) grant <= 4'b0001; // Grant req[0] if it is active
            else if (req[1]) grant <= 4'b0010; // Grant req[1] if it is active
            else if (req[2]) grant <= 4'b0100; // Grant req[2] if it is active
            else if (req[3]) grant <= 4'b1000; // Grant req[3] if it is active
        end
    end
endmodule
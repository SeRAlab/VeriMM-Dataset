module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [2:0] req,
    output reg [2:0] grant
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 3'b000;
        end else begin
            grant <= 3'b000; // Default no grants
            if (req[0]) begin
                grant[0] <= 1'b1; // Grant to req[0]
            end else if (req[1]) begin
                grant[1] <= 1'b1; // Grant to req[1]
            end else if (req[2]) begin
                grant[2] <= 1'b1; // Grant to req[2]
            end
        end
    end
endmodule
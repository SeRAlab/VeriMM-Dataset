module fixed_priority_arbiter(
    input clk,
    input rst,
    input [4:0] req,
    output reg [4:0] grant
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 5'b00000;
        end else begin
            grant <= 5'b00000; // Clear grant initially
            if (req[0]) grant <= 5'b00001; // Grant to req[0] if active
            else if (req[1]) grant <= 5'b00010; // Grant to req[1] if active
            else if (req[2]) grant <= 5'b00100; // Grant to req[2] if active
            else if (req[3]) grant <= 5'b01000; // Grant to req[3] if active
            else if (req[4]) grant <= 5'b10000; // Grant to req[4] if active
        end
    end
endmodule
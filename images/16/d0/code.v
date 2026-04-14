module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] gnt
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gnt <= 4'b0000;
        end else begin
            gnt <= 4'b0000; // Default no grant
            if (req[0]) gnt <= 4'b0001; // Grant to req[0]
            else if (req[1]) gnt <= 4'b0010; // Grant to req[1]
            else if (req[2]) gnt <= 4'b0100; // Grant to req[2]
            else if (req[3]) gnt <= 4'b1000; // Grant to req[3]
        end
    end
endmodule
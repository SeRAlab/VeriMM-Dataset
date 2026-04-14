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
            grant <= 4'b0000; // Default grant to none
            if (req[3]) begin
                grant <= 4'b1000; // Grant to req[3]
            end else if (req[2]) begin
                grant <= 4'b0100; // Grant to req[2]
            end else if (req[1]) begin
                grant <= 4'b0010; // Grant to req[1]
            end else if (req[0]) begin
                grant <= 4'b0001; // Grant to req[0]
            end
        end
    end
endmodule
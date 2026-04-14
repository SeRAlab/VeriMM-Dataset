module fixed_priority_arbiter(
    input wire clk,
    input wire rst,
    input wire [3:0] req,
    output reg [3:0] grant,
    output reg busy
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            busy <= 0;
        end else begin
            if (req[0]) begin
                grant <= 4'b0001; // Grant req[0]
                busy <= 1;
            end else if (req[1]) begin
                grant <= 4'b0010; // Grant req[1]
                busy <= 1;
            end else if (req[2]) begin
                grant <= 4'b0100; // Grant req[2]
                busy <= 1;
            end else if (req[3]) begin
                grant <= 4'b1000; // Grant req[3]
                busy <= 1;
            end else begin
                grant <= 4'b0000; // No grants
                busy <= 0;
            end
        end
    end
endmodule
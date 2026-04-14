module shift_register_8bit (
    input wire [7:0] d,
    input wire clk,
    input wire rst,
    input wire dir,
    input wire enable,
    output reg [7:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 8'b0;
        end else if (enable) begin
            if (dir) begin
                q <= {d[0], d[7:1]};
            end else begin
                q <= {d[6:0], d[7]};
            end
        end
    end
endmodule
module serial2parallel(
    input wire clk,
    input wire rst_n,
    input wire din,
    output wire valid_out,
    output wire [3:0] dout
);

reg [3:0] data = 'd0;
reg [1:0] cnt;
reg valid;
assign dout = data;
assign valid_out = valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 'd0;
        cnt <= 'd0;
        valid <= 'd0;
    end else begin
        data <= {data[2:0], din};
        if (cnt == 'd3) begin
            cnt <= 'd0;
            valid <= 1;
        end else begin
            cnt <= cnt + 'd1;
            valid <= 0;
        end
    end
end

endmodule
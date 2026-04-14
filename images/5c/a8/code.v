module serial2parallel(
    input wire clk,
    input wire rst_n,
    input wire din,
    output wire valid_out,
    output wire [3:0] dout
);

reg [3:0] data = 4'b0;
reg [1:0] cnt = 2'b0;
reg valid;

assign dout = data;
assign valid_out = valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end else begin
        data <= {data[2:0], din};
        if (cnt == 2'b11) begin
            valid <= 1'b1;
            cnt <= 2'b0;
        end else begin
            valid <= 1'b0;
            cnt <= cnt + 2'b1;
        end
    end
end

endmodule
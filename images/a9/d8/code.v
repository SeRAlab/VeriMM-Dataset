module johnson_counter(
    input wire clk,
    input wire rst,
    output reg [3:0] johnson_out
);

always @(posedge clk) begin
    if (rst) begin
        johnson_out <= 4'b0000;
    end else begin
        johnson_out <= {johnson_out[2:0], ~johnson_out[3]};
    end
end

endmodule
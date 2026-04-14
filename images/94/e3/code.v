module johnson_counter(
    input wire clk,
    input wire rst_n,
    output reg [7:0] johnson_out
    );

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        johnson_out <= 8'b00000000;
    else
        johnson_out <= {~johnson_out[7], johnson_out[7:1]};
end

endmodule
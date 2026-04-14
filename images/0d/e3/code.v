module timer_8bit (
    input wire clk,
    input wire enable,
    output reg [7:0] count
);

always @(posedge clk) begin
    if (enable) begin
        count <= (count == 8'hFF) ? 8'h00 : count + 1;
    end
end

endmodule